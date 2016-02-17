class Customer < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_many :recipient_lists
  has_many :domains
  has_many :campaigns
end
