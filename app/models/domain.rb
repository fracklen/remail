class Domain < ActiveRecord::Base
  belongs_to :customer
  validates :customer, presence: true

  validates :name, presence: true, uniqueness: {
    scope: [:customer, :deleted_at]
  }

  validates_presence_of :link_hostname

  scope :active, -> { where(deleted_at: nil)}

end
