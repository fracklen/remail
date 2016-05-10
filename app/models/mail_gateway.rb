class MailGateway < ActiveRecord::Base
  belongs_to :customer
  store :connection_options
end
