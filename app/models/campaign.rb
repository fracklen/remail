class Campaign < ActiveRecord::Base
  belongs_to :recipient_list
  belongs_to :customer
  belongs_to :domain
  has_many :campaign_runs

  validates :recipient_list, presence: true
  validates :customer, presence: true
  validates :domain, presence: true

end
