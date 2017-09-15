class Users::GmailAccount < ActiveRecord::Base
  belongs_to :customer

  validates_presence_of :username
  validates_presence_of :password
end
