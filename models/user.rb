class User < ActiveRecord::Base
  has_many :food_items
  has_many :storage_types

  has_secure_password

  validates :name, :email, presence: true
  validates :name, :email, length: { maximum: 300 }
  validates :email, uniqueness: true
  validates :email, uniqueness: { case_sensitive: false }
end
