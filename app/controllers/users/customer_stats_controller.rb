class Users::CustomerStatsController < CustomerController
  def delivery_history
    render json: format_stats(deliveries)
  end

  def open_history
    render json: format_stats(opens)
  end

  def click_history
    render json: format_stats(clicks)
  end

  private

  def format_stats(data)
    buckets(data).inject({}) do |memo, bucket|
      key = bucket.fetch('key_as_string').split('.').first
      memo[key] = bucket.fetch('doc_count')
      memo
    end
  end

  def buckets(data)
    data
      .fetch('aggregations')
      .fetch('deliveries_over_time')
      .fetch('buckets')
  end

  def deliveries
    DeliveryStatisticsService.new
      .add_filter(:customer_uuid, customer.uuid)
      .set_interval('1h')
      .set_range(from: 'now-1d/d', to: 'now')
      .fetch
  end

  def opens
    filtered_events
      .set_type('open')
      .fetch
  end

  def clicks
    filtered_events
      .set_type('click')
      .fetch
  end

  def customer
    current_user.customer
  end

  def filtered_events
    service = event_service
    if params[:campaign_uuid].present?
      service.add_filter(:campaign_uuid, params[:campaign_uuid])
    end
    if params[:campaign_run_uuid].present?
      service.add_filter(
        :campaign_run_uuid,
        params[:campaign_run_uuid]
      )
    end
    service
  end

  def event_service
    @event_service ||= EventStatisticsService.new
      .add_filter(:customer_uuid, customer.uuid)
      .set_interval('1h')
      .set_range(from: 'now-1d/d', to: 'now')
  end
end
