module Spree
  Product.class_eval do
    belongs_to :user, class_name: 'Spree::User'
    has_many :questions
  end
end
