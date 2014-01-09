module Spree
  User.class_eval do
    has_many :ratings, dependent: :destroy
    has_many :products, dependent: :destroy
    has_many :questions, dependent: :destroy

    before_create :set_role,

    has_attached_file :icon,
      styles: { mini:'32x32>', normal: '256x256>' },
      default_style: :normal,
      url: '/spree/users/:id/:style/:basename.:extension',
      path: ':rails_root/public/spree/users/:id/:style/:basename.:extension',
      default_url: '/assets/default_user.png'

    include Spree::Core::S3Support
    supports_s3 :icon
    
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
end
