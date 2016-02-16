class AddDeletedAtToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :deleted_at, :timestamp, default: nil
  end
end
