class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.references :recipient_list, index: true, foreign_key: true
      t.references :customer, index: true, foreign_key: true
      t.references :domain, index: true, foreign_key: true
      t.string :name
      t.uuid :uuid, null: false, default: 'uuid_generate_v4()', index: true
      t.timestamp :deleted_at, default: nil

      t.timestamps null: false
    end
  end
end
