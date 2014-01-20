Spree::Admin::UsersController.class_eval do


  def update
    if params[:user]
      roles = params[:user].delete("spree_role_ids")
    end

    if @user.update_attributes(user_params)
      if roles
        @user.spree_roles = roles.reject(&:blank?).collect{|r| Spree::Role.find(r)}
      end

      if params[:user][:password].present?
        # this logic needed b/c devise wants to log us out after password changes
        user = Spree::User.reset_password_by_token(params[:user])
        #sign_in(@user, :event => :authentication, :bypass => !Spree::Auth::Config[:signout_after_password_change])
      end
      flash.now[:success] = Spree.t(:account_updated)
      render :edit
    else
      render :edit
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation,
                                   :title, :first_name, :last_name, :phone, :icon)
    end


end
