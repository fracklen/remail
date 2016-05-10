class ElasticStorageService
  attr_reader :index, :type, :documents

  def initialize(index, type, documents)
    @index     = index
    @type      = type
    @documents = documents
  end

  def process
    push_records
  end

  private

  def push_records
    bulk = []
    documents.each do |id, doc|
      bulk << {
        index: {
          _index: index,
          _type: type,
          _id: id,
          data: transformed(doc)
        }
      }
    end
    res = client.bulk body: bulk,
      consistency: 'one',
      replication: 'async'
  end

  # Restore timestamps
  def transformed(doc)
    result = {}
    doc.each do |key, value|
      result[key] = value
      if is_timestamp?(value)
        result[key] = Time.parse(value)
      end
    end
    result
  end

  def client
    return @client if @client
    @client = ::Elasticsearch::Client.new log: false
    @client.transport.reload_connections!
    @client
  end

  def is_timestamp?(value)
    value.is_a?(String) && /\d{4}-\d\d-\d\d \d\d:\d\d:\d\d/.match(value)
  end
end
