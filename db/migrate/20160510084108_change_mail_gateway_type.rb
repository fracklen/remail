class ChangeMailGatewayType < ActiveRecord::Migration
  def change
    rename_column :mail_gateways, :type, :auth_type
  end
end
