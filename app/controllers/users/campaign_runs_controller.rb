class Users::CampaignRunsController < CustomerController
  def create
    @run = CampaignRun.new(campaign: campaign, state: 'PENDING')
    if @run.save
      CampaignRunner.schedule(@run)
      render json: { status: 'OK' }
    else
      render json: { error: @run.errors }
    end
  end

  def destroy
    @run = campaign.campaign_runs.find(params[:id])
    @run.update_attributes(state: 'STOPPING', deleted_at: Time.zone.now)
    render json: { status: 'OK', action: 'delete', id: @run.id }
  end

  def stop
    @run.update_attributes(state: 'STOPPING')
    @run = campaign.campaign_runs.find(params[:id])
    render json: { status: 'OK', id: @run.id, action: 'state_updated', new_state: @run.state}
  end

  def cancel
    @run = campaign.campaign_runs.find(params[:id])
    @run.update_attributes(state: 'CANCELLING')
    render json: { status: 'OK', id: @run.id, action: 'state_updated', new_state: @run.state}
  end

  def resume
    @run = campaign.campaign_runs.find(params[:id])
    @run.update_attributes(state: 'RESUMING')
    CampaignRunner.schedule(@run)
    render json: { status: 'OK', id: @run.id, action: 'state_updated', new_state: @run.state}
  end

  private



  def campaign
    customer.campaigns.find(params[:campaign_id])
  end

  def customer
    current_user.customer
  end
end
