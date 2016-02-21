class AddRejectedToCampaignRun < ActiveRecord::Migration
  def change
    add_column :campaign_runs, :rejected, :integer, default: 0
    add_column :campaign_runs, :processed, :integer, default: 0
    change_column_default :campaign_runs, :sent, 0
  end
end
