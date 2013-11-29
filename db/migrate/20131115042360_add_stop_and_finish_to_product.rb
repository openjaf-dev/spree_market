class AddStopAndFinishToProduct < ActiveRecord::Migration
  def change
      add_column :spree_products, :sell_stop, :boolean, :default => false
      add_column :spree_products, :sell_finish_at, :datetime
  end
end
