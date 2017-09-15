class EventStorageWorker
  include Sidekiq::Worker

  def perform(event_type, data)
    record_event(event_type, data)
  end

  private

  def record_event(event_type, data)
    client.index(
      index: 'events',
      type:  event_type,
      id:    SecureRandom.hex,
      body:  parsed(data)
    )
  end
  def parsed(data)
    data['created_at'] = Time.parse(data['created_at'])
    data
  end

  def client
    return @client if @client
    @client = ::Elasticsearch::Client.new log: false
    # @client.transport.reload_connections!
    @client
  end
end
