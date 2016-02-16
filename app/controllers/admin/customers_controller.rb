class Admin::CustomersController < AdminController
  def index
    @customers = Customer
      .where(deleted_at: nil)
      .all
      .paginate(page: params[:page])
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      redirect_to admin_customers_path, notice: 'Customer created'
    else
      render :new
    end
  end

  def destroy
    @customer = Customer.find(params[:id])
    @customer.deleted_at = Time.zone.now
    @customer.save
    render json: { archived: 'OK', id: params[:id] }
  end

  private

  def customer_params
    params.require(:customer).permit(:name)
  end
end
