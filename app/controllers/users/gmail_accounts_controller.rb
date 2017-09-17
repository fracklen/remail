class Users::GmailAccountsController < ApplicationController
  before_action :set_users_gmail_account, only: [:show, :edit, :update, :destroy, :authorize]

  # GET /users/gmail_accounts
  # GET /users/gmail_accounts.json
  def index
    @users_gmail_accounts = Users::GmailAccount.where(customer: current_user.customer).all
  end

  # GET /users/gmail_accounts/1
  # GET /users/gmail_accounts/1.json
  def show
    @service = GmailService.new(@users_gmail_account.username)
  end

  # GET /users/gmail_accounts/new
  def new
    @users_gmail_account = Users::GmailAccount.new
  end

  def authorize
    @service = GmailService.new(@users_gmail_account.username)
    code = params.require(:code)
    @service.authorize(code)
    render json: {result: 'OK'}
  end

  # GET /users/gmail_accounts/1/edit
  def edit
  end

  # POST /users/gmail_accounts
  # POST /users/gmail_accounts.json
  def create
    @users_gmail_account = Users::GmailAccount.new(users_gmail_account_params)

    respond_to do |format|
      if @users_gmail_account.save
        format.html { redirect_to @users_gmail_account, notice: 'Gmail account was successfully created.' }
        format.json { render :show, status: :created, location: @users_gmail_account }
      else
        format.html { render :new }
        format.json { render json: @users_gmail_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/gmail_accounts/1
  # PATCH/PUT /users/gmail_accounts/1.json
  def update
    respond_to do |format|
      if @users_gmail_account.update(users_gmail_account_params)
        format.html { redirect_to @users_gmail_account, notice: 'Gmail account was successfully updated.' }
        format.json { render :show, status: :ok, location: @users_gmail_account }
      else
        format.html { render :edit }
        format.json { render json: @users_gmail_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/gmail_accounts/1
  # DELETE /users/gmail_accounts/1.json
  def destroy
    @users_gmail_account.destroy
    respond_to do |format|
      format.html { redirect_to users_gmail_accounts_url, notice: 'Gmail account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_users_gmail_account
      @users_gmail_account = Users::GmailAccount.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def users_gmail_account_params
      params
        .require(:users_gmail_account)
        .permit(:username, :password, :sent, :burned)
        .merge(customer)
    end

    def customer
      {
        customer_id: current_user.customer_id
      }
    end
end
