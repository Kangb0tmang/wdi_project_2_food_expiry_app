class User < ActiveRecord::Base
   has_many :fridge_items
   # has_many :freezer_items
   # has_many :pantry_items

   has_secure_password
end
