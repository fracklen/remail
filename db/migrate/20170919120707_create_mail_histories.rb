class CreateMailHistories < ActiveRecord::Migration
  def change
    create_table :mail_histories do |t|
      t.string :sender
      t.integer :emails_sent

      t.timestamps null: false
    end
    add_index :mail_histories, :sender
  end
end
