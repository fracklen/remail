class AddStuffToMailGateway < ActiveRecord::Migration
  def change
    add_column :mail_gateways, :hostname, :string
    add_column :mail_gateways, :port, :integer
    add_column :mail_gateways, :hello, :string
    add_column :mail_gateways, :username, :string
    add_column :mail_gateways, :password, :string
    add_column :mail_gateways, :deleted_at, :timestamp, default: nil
  end
end
