class Admin::UsersController < AdminController
  before_action :set_customers, only: [:new, :create]

  def index
    @users = User
      .where(deleted_at: nil)
      .all
      .order('created_at DESC')
      .paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: 'User created'
    else
      render :new
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.deleted_at = Time.zone.now
    @user.save
    render json: { archived: 'OK', id: params[:id] }
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      :customer_id
    )
  end

  def set_customers
    @customers = Customer.where(deleted_at: nil)
  end

end
