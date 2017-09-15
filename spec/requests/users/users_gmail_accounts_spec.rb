require 'rails_helper'

RSpec.describe "Users::GmailAccounts", type: :request do
  describe "GET /users_gmail_accounts" do
    it "works! (now write some real specs)" do
      get users_gmail_accounts_path
      expect(response).to have_http_status(200)
    end
  end
end
