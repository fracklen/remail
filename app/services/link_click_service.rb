class LinkClickService
  attr_reader :uuid

  def initialize(uuid, params)
    @uuid = uuid
  end

  def destination
    document
      .fetch('_source')
      .fetch('link_to')
  end

  def document
    @document ||= client.get(
     index: 'trackers',
     type:  'link',
     id:    uuid
    )
  end

  def client
    return @client if @client
    @client = ::Elasticsearch::Client.new log: true
    @client.transport.reload_connections!
    @client
  end
end
