class AddBreakpointToCampaignRun < ActiveRecord::Migration
  def change
    add_column :campaign_runs, :breakpoint, :string
    add_column :campaign_runs, :last_error, :string
  end
end
