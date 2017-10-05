class FoodItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :storage_type
end
