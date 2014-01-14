class Spree::Answer < ActiveRecord::Base

  belongs_to :question, touch: true

end
