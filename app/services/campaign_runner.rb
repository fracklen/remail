class CampaignRunner
  attr_reader :campaign_run

  class << self
    def schedule(campaign_run)
      delay.start(campaign_run.id)
    end

    def start(campaign_run_id)
      new(CampaignRun.find(campaign_run_id)).start
    end
  end

  def initialize(campaign_run)
    @campaign_run = campaign_run
  end

  def start
    update_state_start
    # TODO: do stuff
    update_state_end
  end

  def update_state_start
    @campaign_run.state            = 'STARTED'
    @campaign_run.sent             = 0
    @campaign_run.total_recipients = total_recipients
    @campaign_run.save
  end

  def update_state_end
    @campaign_run.state            = 'FINISHED'
    @campaign_run.sent             = total_recipients
    @campaign_run.total_recipients = total_recipients
    @campaign_run.save
  end

  def total_recipients
    recipient_list_service.count[recipient_list.uuid]
  end

  def recipient_list_service
    @recipient_list_service ||= RecipientListService
      .new(campaign_run.campaign.customer)
  end

  def recipient_list
    campaign_run.campaign.recipient_list
  end

end
