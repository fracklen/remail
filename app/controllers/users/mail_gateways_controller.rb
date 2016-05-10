class Users::MailGatewaysController < CustomerController
  def index
    @mail_gateways = MailGateway
      .where(deleted_at: nil)
      .all
      .paginate(page: params[:page])
  end

  def new
    @mail_gateway = MailGateway.new
  end

  def create
    @mail_gateway = MailGateway.new(gateway_params)
    if @mail_gateway.save
      redirect_to users_mail_gateways_path, notice: 'Mail Gateway created'
    else
      render :new
    end
  end

  def update
    @mail_gateway = MailGateway.find(params[:id])
    if @mail_gateway.update(gateway_params)
      redirect_to users_mail_gateways_path, notice: 'Mail Gateway updated'
    else
      render :new
    end
  end

  def show
    @mail_gateway = MailGateway.find(params[:id])
  end

  def destroy
    @mail_gateway = MailGateway.find(params[:id])
    @mail_gateway.deleted_at = Time.zone.now
    @mail_gateway.save
    render json: { archived: 'OK', id: params[:id] }
  end

  private

  def gateway_params
    params
      .require(:mail_gateway)
      .permit(*fields)
      .merge(customer)
  end

  def customer
    {
      customer_id: current_user.customer_id
    }
  end

  def fields
    [
      :name,
      :hostname,
      :port,
      :auth_type,
      :hello,
      :username,
      :password
    ]
  end
end
