class Spree::UsersController < Spree::StoreController
  ssl_required
  skip_before_filter :set_current_order, :only => :show
  prepend_before_filter :load_object, :only => [:show, :edit, :update]
  prepend_before_filter :authorize_actions, :only => :new

  include Spree::Core::ControllerHelpers

  def show
    @orders = @user.orders.complete.order('completed_at desc')
    @stopped_products   = @user.products.stopped.uniq.count
    @finished_products  = @user.products.finished.uniq.count
    @available_products = @user.products.available.uniq.count
    @questions_to_user  = @user.questions.order(created_at: :asc )
    @products = @user.products
  end

  def create
    @user = Spree::User.new(user_params)
    if @user.save

      if current_order
        session[:guest_token] = nil
      end

      redirect_back_or_default(root_url)
    else
      render :new
    end
  end

  def update
    if @user.update_attributes(user_params)
      if params[:user][:password].present?
        # this logic needed b/c devise wants to log us out after password changes
        user = Spree::User.reset_password_by_token(params[:user])
        sign_in(@user, :event => :authentication, :bypass => !Spree::Auth::Config[:signout_after_password_change])
      end
      redirect_to spree.account_url, :notice => Spree.t(:account_updated)
    else
      render :edit
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

    def load_object
      if params[:id]
        @user = Spree::User.find(params[:id])
      else
        @user ||= spree_current_user
        authorize! params[:action].to_sym, @user
      end

    end

    def authorize_actions
      authorize! params[:action].to_sym, Spree::User.new
    end

    def accurate_title
      Spree.t(:my_account)
    end
end
