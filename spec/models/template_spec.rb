require 'rails_helper'

RSpec.describe Template, type: :model do
  let(:customer) { Customer.create(name: 'Spammers Inc.')}

  it 'creates a template' do
  	Template.create!(
  	  name: 'Template 1',
  	  customer: customer,
  	  subject: 'Buy our stuff',
  	  body: 'Buy our stuff NOW!!'
	)
  end
end
