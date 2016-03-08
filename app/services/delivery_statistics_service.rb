class DeliveryStatisticsService
  attr_reader :filters

  def initialize
    @filters = {}
  end

  def add_filter(key, value)
    @filters[key] = value
    self
  end

  def fetch()
    client.search(
      size: 0,
      index: 'deliveries',
      type: 'delivery',
      body: query
    )
  end

  def query
    {
      "aggs" => {
        "filtered" => {
          "filter" => {
            "bool" => {
              "must" => format_filters
            }
          },
          "aggs" => {
            "deliveries_over_time" => {
              "date_histogram" => {
                "field" => "created_at",
                "interval" => "hour"
              }
            }
          }
        }
      }
    }
  end

  def format_filters
    @filters.map do |key, value|
      {
        "term" => {
          "#{key}.raw" => value
        }
      }
    end
  end

  def client
    return @client if @client
    @client = ::Elasticsearch::Client.new log: true
    @client.transport.reload_connections!
    @client
  end
end
