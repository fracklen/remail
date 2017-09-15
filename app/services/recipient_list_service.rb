class RecipientListService
  attr_reader :customer

  def initialize(customer)
    @customer = customer
  end

  def count
    @count ||= hashify
  end

  private

  def hashify
    buckets.map do |bucket|
      [bucket['key'], bucket['doc_count']]
    end.to_h
  end

  def buckets
    @buckets ||= query['aggregations']['lists']['buckets']
  end

  def query(limit: 0)
    client.search(index: 'recipients', type: 'recipient', body: {
      size: limit,
      query: {
        match: { 'customer_uuid.raw' => customer.uuid }
      },
      aggs: {
        lists: {
          terms: {
            field: 'recipient_list_uuid.raw'
          }
        }
      }
    })
  end

  def client
    return @client if @client
    @client = ::Elasticsearch::Client.new log: false
    # @client.transport.reload_connections!
    @client
  end
end

