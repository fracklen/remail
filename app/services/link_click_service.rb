class LinkClickService
  attr_reader :uuid, :request

  def initialize(uuid, request)
    @uuid = uuid
    @request = request
  end

  def destination
    record_event
    source.fetch('link_to')
  end

  def document
    @document ||= client.get(
     index: 'trackers',
     type:  'link',
     id:    uuid
    )
  end

  def record_event
    EventStorageWorker.perform_async('click', event_data)
  end

  def event_data
    {
      created_at:           Time.zone.now,
      message_id:           source.fetch('message_id'),
      recipient_uuid:       source.fetch('recipient_uuid'),
      recipient_list_uuid:  source.fetch('recipient_list_uuid'),
      customer_uuid:        source.fetch('customer_uuid'),
      campaign_uuid:        source.fetch('campaign_uuid'),
      campaign_run_uuid:    source.fetch('campaign_run_uuid'),
      link_to:              source.fetch('link_to'),
      user_agent:           request.user_agent,
      ip:                   request.remote_ip
    }
  end

  def source
    document.fetch('_source')
  end

  def client
    return @client if @client
    @client = ::Elasticsearch::Client.new log: false
    # @client.transport.reload_connections!
    @client
  end
end
