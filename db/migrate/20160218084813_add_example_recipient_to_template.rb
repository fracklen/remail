class AddExampleRecipientToTemplate < ActiveRecord::Migration
  def change
    add_column :templates, :example_recipient, :text
  end
end
