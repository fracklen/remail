class CampaignWorker
  include Sidekiq::Worker
  def perform(campaign_run_id)
    campaign_run = CampaignRun.find(campaign_run_id)
    CampaignRunner.new(campaign_run).start
  end
end
