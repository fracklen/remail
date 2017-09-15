require 'rails_helper'

RSpec.describe "users/gmail_accounts/show", type: :view do
  before(:each) do
    @users_gmail_account = assign(:users_gmail_account, Users::GmailAccount.create!(
      :customer => nil,
      :username => "Username",
      :password => "Password",
      :sent => 1,
      :burned => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Username/)
    expect(rendered).to match(/Password/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/false/)
  end
end
