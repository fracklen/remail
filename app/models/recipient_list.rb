class RecipientList < ActiveRecord::Base
  belongs_to :customer
  validates :customer, presence: true
  validates :name, presence: true, uniqueness: { scope: :customer_id }

  scope :active, -> { where(deleted_at: nil) }
end
