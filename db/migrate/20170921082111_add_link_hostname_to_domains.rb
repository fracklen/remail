class AddLinkHostnameToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :link_hostname, :string
  end
end
