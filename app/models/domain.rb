class Domain < ActiveRecord::Base
  belongs_to :customer
  validates :customer, presence: true

  validates :name, presence: true, uniqueness: {
    scope: [:customer, :deleted_at]
  }

  scope :active, -> { where(deleted_at: nil)}

end
