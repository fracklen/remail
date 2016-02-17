class CreateCampaignRuns < ActiveRecord::Migration
  def change
    create_table :campaign_runs do |t|
      t.references :campaign, index: true, foreign_key: true
      t.uuid :uuid, index: true, default: 'uuid_generate_v4()', null: false
      t.string :name

      t.timestamps null: false
    end
  end
end
