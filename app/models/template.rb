class Template < ActiveRecord::Base
  belongs_to :customer

  validates :customer, presence: true
  validates :name, presence: true
  validates :subject, presence: true
  validates :body, presence: true

  def example_data
    JSON.parse(self.example_recipient)
  rescue
    {}
  end
end
