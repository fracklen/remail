class Users::DomainsController < CustomerController
  def index
    @domains = Domain
      .where(deleted_at: nil)
      .all
      .paginate(page: params[:page])
  end

  def new
    @domain = Domain.new
  end

  def create
    @domain = Domain.new(domain_params)
    if @domain.save
      redirect_to users_domains_path, notice: 'Domain created'
    else
      render :new
    end
  end

  def show
    @domain = Domain.find(params[:id])
  end

  def destroy
    @domain = Domain.find(params[:id])
    @domain.deleted_at = Time.zone.now
    @domain.save
    render json: { archived: 'OK', id: params[:id] }
  end

  private

  def domain_params
    params.require(:domain).permit(:name).merge(customer)
  end

  def customer
    {
      customer_id: current_user.customer_id
    }
  end
end
