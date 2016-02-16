class Users::RecipientListsController < CustomerController
  def index
    @recipient_lists = RecipientList
      .where(deleted_at: nil)
      .all
      .paginate(page: params[:page])
  end

  def new
    @recipient_list = RecipientList.new
  end

  def create
    @recipient_list = RecipientList.new(recipient_list_params)
    if @recipient_list.save
      redirect_to users_recipient_lists_path, notice: 'Recipient List created'
    else
      render :new
    end
  end

  def destroy
    @recipient_list = RecipientList.find(params[:id])
    @recipient_list.deleted_at = Time.zone.now
    @recipient_list.save
    render json: { archived: 'OK', id: params[:id] }
  end

  private

  def recipient_list_params
    params.require(:recipient_list).permit(:name).merge(customer)
  end

  def customer
    {
        customer_id: current_user.customer_id
    }
  end
end
