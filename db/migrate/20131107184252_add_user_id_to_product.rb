class AddUserIdToProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :user_id, :integer
  end
end
