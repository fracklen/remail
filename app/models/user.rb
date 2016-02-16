class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :customer
  validates :customer, presence: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
