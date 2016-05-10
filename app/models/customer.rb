class Customer < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_many :recipient_lists
  has_many :domains
  has_many :campaigns
  has_many :templates
  has_many :mail_gateways
end
