class CreateSpreeRatings < ActiveRecord::Migration
  def change
    create_table :spree_ratings do |t|
      t.float :rating
      t.references :user

      t.timestamps
    end
  end
end
