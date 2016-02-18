class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.references :customer, index: true, foreign_key: true
      t.string :name
      t.string :subject
      t.text :body
      t.timestamp :deleted_at, null: true, default: nil

      t.timestamps null: false
    end
  end
end
