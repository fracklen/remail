class Users::RecipientListUploadsController < CustomerController
  def create
    @upload = RecipientListUpload.new(meta_data)
    @upload.csv_data = upload.read
    @state = 'READY'
    if @upload.save
      RecipientUploadProcessor.process_delayed(@upload)
      redirect_to users_recipient_lists_path, notice: 'Upload complete. Processing...'
    else
      render :new
    end
  end

  private

  def upload
    params[:recipient_list_upload][:csv_data]
  end

  def upload_params
    params.require(:recipient_list_upload)
      .permit(:csv_data)
      .merge(meta_data)
  end

  def meta_data
    {
      created_by: current_user,
      recipient_list: list
    }
  end

  def list
    current_user
      .customer
      .recipient_lists
      .find(params[:recipient_list_upload][:recipient_list_id])
  end
end
