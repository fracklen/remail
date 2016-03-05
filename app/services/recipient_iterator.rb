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
    unsubscribed = find_unsubscribed_emails(results)
    @scroll_id = results['_scroll_id']

    results['hits']['hits'].reject do |hit|
      unsubscribed[hit['_source']['email']]
    end
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

  def find_unsubscribed_emails(elastic_response)
    emails = elastic_response['hits']['hits'].map do |recipient|
      recipient['_source']['email']
    end
    response = fetch_unsubscriptions(customer.uuid, emails)
    response['hits']['hits'].inject({}) do |memo, hit|
      memo[hit['_source']['email']] = true
      memo
    end
  end

  def fetch_unsubscriptions(customer_uuid, emails)
    client.search(index: 'unsubscriptions',
      type: 'unsubscriber',
      body: {
        query: {
          bool: {
            must: [
              {
                terms: {
                  'email.raw' => emails
                }
              },
              {
                term: {
                  'customer_uuid.raw' => customer_uuid
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
    @client = ::Elasticsearch::Client.new log: true
    @client.transport.reload_connections!
    @client
  end
end
