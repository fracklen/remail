class RecipientListUpload < ActiveRecord::Base
  belongs_to :recipient_list
  validates :csv_data, presence: true
  belongs_to :created_by, class_name: 'User'
end
