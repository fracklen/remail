class EventStatisticsService
  attr_reader :type, :filters, :interval, :range

  def initialize
    @filters = {}
    @interval = 'hour'
    @range =  {
      from: 'now-1d/d',
      to:   'now'
    }
    @type = nil
  end

  def set_type(type)
    @type = type
    self
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
    client.search(
      size: 0,
      index: 'events',
      type: type,
      body: query
    )
  end

  def query
    {
      "aggs" => {
        "deliveries_over_time" => {
          "date_histogram" => {
            "field" => "created_at",
            "interval" => interval
          }
        }
      },
      "query" => {
        "bool" => {
          "must" => format_terms + [date_range]
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

  def format_terms
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
    @client = ::Elasticsearch::Client.new log: false
    # @client.transport.reload_connections!
    @client
  end
end
