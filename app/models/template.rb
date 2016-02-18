class Template < ActiveRecord::Base
  belongs_to :customer

  validates :customer, presence: true
  validates :name, presence: true
  validates :subject, presence: true
  validates :body, presence: true

  def example_data
    JSON.parse(example_recipient)['custom_data']
  rescue
    {}
  end
end
