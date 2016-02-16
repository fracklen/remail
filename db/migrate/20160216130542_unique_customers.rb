class UniqueCustomers < ActiveRecord::Migration
  def change
    add_index :customers, :name, unique: true
    add_index :customers, :uuid, unique: true
  end
end
