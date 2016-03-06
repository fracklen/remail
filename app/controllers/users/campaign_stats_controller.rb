class Users::CampaignStatsController < CustomerController
  def delivery_history
    render json: format_stats
  end

  private

  def format_stats
    buckets.inject({}) do |memo, bucket|
      key = bucket.fetch('key_as_string').split('T').first
      memo[key] = bucket.fetch('doc_count')
      memo
    end
  end

  def buckets
    stats
      .fetch('aggregations')
      .fetch("deliveries")
      .fetch("buckets")
      .fetch("campaign")
      .fetch("deliveries_over_time")
      .fetch('buckets')
  end

  def stats
    DeliveryStatisticsService.new(campaign).fetch
  end

  def campaign
    customer.campaigns.find(params[:campaign_id])
  end

  def customer
    current_user.customer
  end
end
