class DeliveryStatisticsService
  attr_reader :campaign

  def initialize(campaign)
    @campaign = campaign
  end

  def fetch()
    client.search(
      size: 0,
      index: 'deliveries',
      type: 'delivery',
      body: query_campaign
    )
  end

  def query_campaign
    {
      "aggs" => {
        "deliveries" => {
          "filters" => {
            "filters" => {
              "campaign" => {
                "term" => {
                  "campaign_uuid.raw" => campaign.uuid
                }
              }
            }
          },
          "aggs" => {
            "deliveries_over_time" => {
              "date_histogram" => {
                "field" => "created_at",
                "interval" => "day"
              }
            }
          }
        }
      }
    }
  end

  def client
    return @client if @client
    @client = ::Elasticsearch::Client.new log: true
    @client.transport.reload_connections!
    @client
  end
end
