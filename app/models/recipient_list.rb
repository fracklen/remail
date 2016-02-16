class RecipientList < ActiveRecord::Base
  belongs_to :customer
  validates :customer, presence: true
  validates :name, presence: true, uniqueness: { scope: :customer_id }
end
