class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.references :customer, index: true, foreign_key: true
      t.string :name
      t.timestamp :deleted_at, default: nil

      t.timestamps null: false
    end

    add_index :domains, [:customer_id, :name, :deleted_at], unique: true
  end
end
