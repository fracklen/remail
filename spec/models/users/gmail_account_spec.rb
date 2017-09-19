require 'rails_helper'

RSpec.describe Users::GmailAccount, type: :model do

  let(:account) do
    Users::GmailAccount.create!(username: 'foo@bar.dk', password: 'secret')
  end

  before do
    Users::MailHistory.create!(gmail_account: account, mails: 50)
    Users::MailHistory.create!(gmail_account: account, mails: 50)
    Users::MailHistory.create!(gmail_account: account, mails: 50)
    Users::MailHistory.create!(gmail_account: account, mails: 50)
    Users::MailHistory.create!(gmail_account: account, mails: 42)
  end

  it "creates the account" do
    expect(account.id).to be_present
  end

  it "has created history" do
    expect(Users::MailHistory.count).to eq(5)
    Users::MailHistory.all.each do |mh|
      p mh
    end
  end

  it "counts mail history" do
    expect(account.mail_histories.sum(:mails))
      .to eq(242)
  end
end
