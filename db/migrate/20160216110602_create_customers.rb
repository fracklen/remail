class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'

      t.timestamps null: false
    end
  end
end
