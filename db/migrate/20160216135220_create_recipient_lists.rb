class CreateRecipientLists < ActiveRecord::Migration
  def change
    create_table :recipient_lists do |t|
      t.references :customer
      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'
      t.string :name
      t.timestamp :deleted_at, default: nil

      t.timestamps null: false
    end
  end
end
