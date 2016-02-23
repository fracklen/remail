class RecipientIterator
  attr_reader :recipient_list, :scroll_id

  def initialize(recipient_list, bulk_size = 1000)
    @recipient_list = recipient_list
    @scroll_id = nil
    @bulk_size = bulk_size
  end

  def find_each
    results = process_results
    while results.any?
      results.each do |recipient|
        yield(recipient['_id'], recipient['_source'])
      end
      results = process_results
    end

  end

  def process_results
    results = get_next
    @scroll_id = results['_scroll_id']
    return results['hits']['hits']
  end

  def get_next
    return scroll if scroll_id
    start_query
  end

  def scroll
    client.scroll(
      scroll: '1m',
      scroll_id: @scroll_id
    )
  end

  def start_query
    client.search(index: 'recipients',
      type: 'recipient',
      scroll: '1m',
      size: @bulk_size,
      body: {
        query: {
          bool: {
            must: [
              {
                term: {
                  'customer_uuid.raw' => customer.uuid
                }
              },
              {
                term: {
                  'recipient_list_uuid.raw' => recipient_list.uuid
                }
              }
            ]
          }
        }
      }
    )
  end

  def customer
    @customer ||= recipient_list.customer
  end

  def client
    return @client if @client
    @client = ::Elasticsearch::Client.new log: false
    @client.transport.reload_connections!
    @client
  end
end
