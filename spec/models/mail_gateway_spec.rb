require 'rails_helper'

describe MailGateway, type: :model do
  let(:customer) { Customer.create(name: "Spammers Inc.") }

  before do
    @mgw = MailGateway.create(
      customer_id:        customer.id,
      name:               'ColdMail',
      auth_type:          'PLAIN',
      connection_options: nil,
      hostname:           'smtp.coldmail.com',
      port:               25,
      hello:              'ColdMail',
      username:           'spammer',
      password:           'bezerk'
    )
  end

  it 'can create gateway' do
    expect(@mgw).not_to be_new_record
  end

end
