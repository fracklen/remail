require 'rails_helper'

RSpec.describe "users/gmail_accounts/edit", type: :view do
  before(:each) do
    @users_gmail_account = assign(:users_gmail_account, Users::GmailAccount.create!(
      :customer => nil,
      :username => "MyString",
      :password => "MyString",
      :sent => 1,
      :burned => false
    ))
  end

  it "renders the edit users_gmail_account form" do
    render

    assert_select "form[action=?][method=?]", users_gmail_account_path(@users_gmail_account), "post" do

      assert_select "input#users_gmail_account_customer_id[name=?]", "users_gmail_account[customer_id]"

      assert_select "input#users_gmail_account_username[name=?]", "users_gmail_account[username]"

      assert_select "input#users_gmail_account_password[name=?]", "users_gmail_account[password]"

      assert_select "input#users_gmail_account_sent[name=?]", "users_gmail_account[sent]"

      assert_select "input#users_gmail_account_burned[name=?]", "users_gmail_account[burned]"
    end
  end
end
