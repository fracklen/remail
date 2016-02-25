class UnsubscriptionsService
  attr_reader :message_id, :request

  def initialize(message_id, request)
    @message_id = message_id
    @request    = request
  end

  def unsubscribe!
    client.index(
      index: 'unsubscriptions',
      type: 'unsubscriber',
      id:   message_id,
      body: delivery_data
    )
  end

  def document
    @document ||= client.get(
     index: 'deliveries',
     type:  'delivery',
     id:    message_id
    )
  end

  def delivery_data
    {
      campaign_run_uuid:   source.fetch('campaign_run_uuid'),
      campaign_uuid:       source.fetch('campaign_uuid'),
      created_at:          source.fetch('created_at'),
      customer_uuid:       source.fetch('customer_uuid'),
      email:               source.fetch('email'),
      ip:                  request.remote_ip,
      message_id:          source.fetch('message_id'),
      recipient_list_uuid: source.fetch('recipient_list_uuid'),
      recipient_uuid:      source.fetch('recipient_uuid'),
      user_agent:          request.user_agent
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
