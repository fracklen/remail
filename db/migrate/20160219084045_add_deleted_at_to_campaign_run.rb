class AddDeletedAtToCampaignRun < ActiveRecord::Migration
  def change
    add_column :campaign_runs, :deleted_at, :timestamp, default: nil
  end
end
