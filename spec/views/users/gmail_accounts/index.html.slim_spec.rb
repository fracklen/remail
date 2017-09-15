require 'rails_helper'

RSpec.describe "users/gmail_accounts/index", type: :view do
  before(:each) do
    assign(:users_gmail_accounts, [
      Users::GmailAccount.create!(
        :customer => nil,
        :username => "Username",
        :password => "Password",
        :sent => 1,
        :burned => false
      ),
      Users::GmailAccount.create!(
        :customer => nil,
        :username => "Username",
        :password => "Password",
        :sent => 1,
        :burned => false
      )
    ])
  end

  it "renders a list of users/gmail_accounts" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Username".to_s, :count => 2
    assert_select "tr>td", :text => "Password".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
