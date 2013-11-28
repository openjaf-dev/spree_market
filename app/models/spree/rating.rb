class Spree::Rating < ActiveRecord::Base

   belongs_to :user

   #attr_accessible :rating, :user_id

end
