class ElasticStatusService
  def initialize

  end

  def status
    client.cluster.health['status']
  rescue
    'red'
  end

  private

  def client
    return @client if @client
    @client = ::Elasticsearch::Client.new log: false
    #@client.transport.reload_connections!
    @client
  end
end
