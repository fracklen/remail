require 'rails_helper'

RSpec.describe User, type: :model do
  let(:customer) { Customer.create(name: 'Spammers Inc.')}

  it 'creates a user' do
  	User.create!(
  		name: 'The Spammer',
  		email: 'spam@spam.dk',
  		password: 's3cr3t!!',
  		password_confirmation: 's3cr3t!!',
  		customer: customer
		)
  end
end
