class AddTemplateToCampaign < ActiveRecord::Migration
  def change
    add_reference :campaigns, :template, index: true, foreign_key: true
  end
end
