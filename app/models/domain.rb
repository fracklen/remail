class Domain < ActiveRecord::Base
  belongs_to :customer
  validates :name, presence: true, uniqueness: {
    scope: [:customer, :deleted_at]
  }
end
