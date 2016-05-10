class CreateMailGateways < ActiveRecord::Migration
  def change
    create_table :mail_gateways do |t|
      t.references :customer, index: true, foreign_key: true
      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'
      t.string :name
      t.string :type
      t.text :connection_options

      t.timestamps null: false
    end
  end
end
