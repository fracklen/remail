class CreateRecipientListUploads < ActiveRecord::Migration
  def change
    create_table :recipient_list_uploads do |t|
      t.binary :csv_data, limit: 500.megabyte
      t.references :recipient_list, index: true, foreign_key: true
      t.integer :created_by_id, index: true
      t.string :state

      t.timestamps null: false
    end
  end
end
