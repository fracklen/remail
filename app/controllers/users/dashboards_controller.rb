class Users::DashboardsController < CustomerController
  before_action :set_customer

  def index

  end

  private

  def set_customer
    @customer = current_user.customer
  end
end
