Spree::Admin::ResourceController.class_eval do

  def permitted_resource_params
    params[:product].merge!(user_id: @current_spree_user.id) if params[:product]
    params.require(object_name).permit!
  end

  def collection_actions
    [:index, :sell_stop, :finished]
  end

end