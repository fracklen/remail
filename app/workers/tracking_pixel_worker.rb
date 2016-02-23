class TrackingPixelWorker
  include Sidekiq::Worker

  def perform(uuid, request_data)
    TrackingPixelService.new(uuid, request_data).record_event
  end
end
