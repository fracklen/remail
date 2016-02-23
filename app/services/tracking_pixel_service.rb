class TrackingPixelService
  attr_reader :uuid, :request

  class << self
    def process_open(uuid, request)
      request_data = {
        created_at: Time.zone.now,
        user_agent: request.user_agent,
        ip:         request.remote_ip
      }
      TrackingPixelWorker.perform_async(uuid, request_data)
    end
  end

  def initialize(uuid, request)
    @uuid = uuid
    @request = request
  end

  def record_event
    EventStorageWorker.perform_async('open', event_data)
  end

  def document
    @document ||= client.get(
     index: 'deliveries',
     type:  'delivery',
     id:    uuid
    )
  end

  def event_data
    {
      campaign_run_uuid:   source.fetch('campaign_run_uuid'),
      campaign_uuid:       source.fetch('campaign_uuid'),
      created_at:          request.fetch('created_at'),
      customer_uuid:       source.fetch('customer_uuid'),
      ip:                  request.fetch('ip'),
      message_id:          source.fetch('message_id'),
      recipient_list_uuid: source.fetch('recipient_list_uuid'),
      recipient_uuid:      source.fetch('recipient_uuid'),
      user_agent:          request.fetch('user_agent')
    }
  end

  def source
    document.fetch('_source')
  end

  def client
    return @client if @client
    @client = ::Elasticsearch::Client.new log: false
    @client.transport.reload_connections!
    @client
  end

end
