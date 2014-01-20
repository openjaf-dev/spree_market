module Spree
  UsersController.class_eval do

  def show
    @orders = @user.orders.complete.order('completed_at desc')
    if spree_current_user.admin?
      @stopped_products   = Spree::Product.stopped.uniq.count
      @finished_products  = Spree::Product.finished.uniq.count
      @available_products = Spree::Product.available.uniq.count
    else
      @stopped_products   = @user.products.stopped.uniq.count
      @finished_products  = @user.products.finished.uniq.count
      @available_products = @user.products.available.uniq.count
    end
    @questions_to_user  = @user.questions.order(created_at: :asc)
    @products = @user.products
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation,
                                   :title, :first_name, :last_name, :phone, :icon)
    end

    def load_object
      if params[:id]
        @user = Spree::User.find(params[:id])
      else
        @user ||= spree_current_user
        authorize! params[:action].to_sym, @user
      end
    end
  
  end
end
