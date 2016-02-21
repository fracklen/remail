class CampaignRun < ActiveRecord::Base
  belongs_to :campaign

  validates :campaign, presence: true

  scope :visible, -> { where(deleted_at: nil) }

  def progress_pct
    (100.0 * ((self.processed.to_i) / self.total_recipients.to_f)).round(1)
  end

  def success_rate
    (100.0 * self.sent.to_i / self.processed.to_f).round(1)
  end

end
