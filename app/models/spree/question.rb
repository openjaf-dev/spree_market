class Spree::Question < ActiveRecord::Base

  belongs_to :product, class_name: "Spree::Product"
  belongs_to :user, class_name: "Spree::User"


end
