require 'rails_helper'

RSpec.describe MailHistory, type: :model do
  let(:customer) { Customer.create(name: 'Spammers Inc.')}

  it 'can create mail history' do
  	MailHistory.create!(
  		sender: 'me@me.com',
  		emails_sent: 42
  	)
  end
end
