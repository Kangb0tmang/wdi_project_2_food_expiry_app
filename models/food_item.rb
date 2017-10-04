class Food_Item < ActiveRecord::Base
   belongs_to :user
   belongs_to :storage_type
end
