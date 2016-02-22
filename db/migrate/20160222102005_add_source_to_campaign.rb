class AddSourceToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :from_email, :string
    add_column :campaigns, :reply_to_email, :string
  end
end
