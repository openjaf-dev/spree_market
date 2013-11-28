Spree::User.class_eval do

  has_many :ratings
  has_many :products


  before_create :set_role,
  
  def set_role
    role = Spree::Role.find_by name:"user"
    self.role_ids = role.id
  end

  def self.ratings
    count = Spree::Rating.where(user_id:self.id).count
    rating = 0
    Spree::Rating.where(user_id:self.id).each do |ret|
       rating += ret.rating
    end
    rating/count
  end
end
