class Users::CampaignsController < CustomerController
  before_action :set_dependencies, only: [:new, :create]

  def index
    @campaigns = Campaign
      .where(deleted_at: nil)
      .all
      .paginate(page: params[:page])
  end

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.new(campaign_params)
    if @campaign.save
      redirect_to users_campaigns_path, notice: 'Campaign created'
    else
      render :new
    end
  end

  def show
    @campaign = Campaign.find(params[:id])
  end

  def destroy
    @campaign = Campaign.find(params[:id])
    @campaign.deleted_at = Time.zone.now
    @campaign.save
    render json: { archived: 'OK', id: params[:id] }
  end

  private

  def campaign_params
    params.require(:campaign).permit(
      :name,
      :recipient_list_id,
      :domain_id
    ).merge(customer)
  end

  def customer
    {
      customer_id: current_user.customer_id
    }
  end

  def set_dependencies
    @recipient_lists = current_user.customer.recipient_lists.active
    @domains = current_user.customer.domains.active
  end
end
