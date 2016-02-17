class AddStateToCampaignRun < ActiveRecord::Migration
  def change
    add_column :campaign_runs, :state, :string
    add_column :campaign_runs, :total_recipients, :integer
    add_column :campaign_runs, :sent, :integer
  end
end
