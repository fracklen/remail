require 'rails_helper'

describe RecipientList, type: :model do

	let(:customer) { Customer.create(name: "Spammers Inc.") }

  before do
  	@rec_list = RecipientList.create(name: 'The List', customer: customer)
    @deleted = RecipientList.create(name: 'The List', customer: customer, deleted_at: 1.day.ago)
  end

  let(:invalid_list) { RecipientList.create(name: '', customer: customer) }

  it "finds active lists" do
    expect(RecipientList.active).to eq [@rec_list]
  end

  it 'errors on missing name' do
    expect(invalid_list).not_to be_valid
  end

  it 'does not find deleted lists' do
    expect(RecipientList.active).not_to include(@deleted)
  end

end
