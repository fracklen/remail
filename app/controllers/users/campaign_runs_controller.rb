class Users::CampaignRunsController < CustomerController
  def create
    @run = CampaignRun.new(campaign: campaign)
    if @run.save
      CampaignRunner.schedule(@run)
      render json: { status: 'OK' }
    else
      render json: { error: @run.errors }
    end
  end

  private

  def campaign
    customer.campaigns.find(params[:campaign_id])
  end

  def customer
    current_user.customer
  end
end
