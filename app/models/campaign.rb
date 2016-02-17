class Campaign < ActiveRecord::Base
  belongs_to :recipient_list
  belongs_to :customer
  belongs_to :domain

  validates :recipient_list, presence: true
  validates :customer, presence: true
  validates :domain, presence: true
end
