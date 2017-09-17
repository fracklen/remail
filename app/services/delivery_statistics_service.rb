class DeliveryStatisticsService
  attr_reader :filters, :interval, :range

  def initialize
    @filters = {}
    @interval = 'hour'
    @range =  {
      from: 'now-1d/d',
      to:   'now'
    }
  end

  def add_filter(key, value)
    @filters[key] = value
    self
  end

  def set_interval(interval)
    @interval = interval
    self
  end

  def set_range(range)
    @range = range
    self
  end

  def fetch()
    Rails.logger.info(query.to_json)
    client.search(
      size: 0,
      index: 'deliveries',
      type: 'delivery',
      body: query
    )
  end

  def query
    {
      "query" => {
        "constant_score" => {
          "filter" => format_filters
        }
      },
      "aggs" => {
        "deliveries_over_time" => {
          "date_histogram" => {
            "field" => "created_at",
            "interval" => interval
          }
        }
      }
    }
  end

  def date_range
    {
      "range" => {
        "created_at" => {
          "gte" => range[:from],
          "lt"  => range[:to]
        }
      }
    }
  end

  def format_filters
    f = date_range
    @filters.each do |key, value|
      f[key] = {
        "term" => {
          "#{key}.raw" => value
        }
      }
    end
    return f
  end

  def client
    return @client if @client
    @client = ::Elasticsearch::Client.new log: false
    # @client.transport.reload_connections!
    @client
  end
end
