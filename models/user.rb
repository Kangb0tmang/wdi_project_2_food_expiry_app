class User < ActiveRecord::Base
   has_many :food_items
   has_many :storage_types

   has_secure_password
end
