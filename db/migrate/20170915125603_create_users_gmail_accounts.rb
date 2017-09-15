class CreateUsersGmailAccounts < ActiveRecord::Migration
  def change
    create_table :users_gmail_accounts do |t|
      t.references :customer, index: true, foreign_key: true
      t.string :username
      t.string :password
      t.integer :sent, default: 0
      t.boolean :burned, default: false

      t.timestamps null: false
    end
    add_index :users_gmail_accounts, :username
  end
end
