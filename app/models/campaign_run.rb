class CampaignRun < ActiveRecord::Base
  belongs_to :campaign

  validates :campaign, presence: true
end
