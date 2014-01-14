module Spree::Admin
    ProductsController.class_eval do 

      before_filter :load_data, :except => [:index, :finished, :sell_stop]

      #finished_admin_products_parth
      def finished
        params[:q] = {}
        params[:q][:deleted_at_null] ||= "1"
        params[:q][:sell_stop_false] ||= "1"
        params[:q][:sell_finish_at_lteq] ||= Time.now
        if !spree_current_user.admin?
          params[:q][:user_id_eq] ||= spree_current_user.id
        end
        params[:q][:s] ||= "name asc"

        @search = Spree::Product.ransack(params[:q])
        @finished = @search.result.
            group_by_products_id.
            includes(product_includes).
            page(params[:page]).
            per(Spree::Config[:admin_products_per_page])

        if params[:q][:s].include?("master_default_price_amount")
          # PostgreSQL compatibility
          @finished = @finished.group("spree_prices.amount")
        end
        respond_with(@finished)
      end

      #sell_stop_admin_products_path
      def sell_stop
        params[:q] = {}
        params[:q][:deleted_at_null] ||= "1"
        params[:q][:sell_stop_true] ||= "1"
        if !spree_current_user.admin?
          params[:q][:user_id_eq] ||= spree_current_user.id
        end
        params[:q][:s] ||= "name asc"

        @search = Spree::Product.ransack(params[:q])
        @stopped = @search.result.
            group_by_products_id.
            includes(product_includes).
            page(params[:page]).
            per(Spree::Config[:admin_products_per_page])

        if params[:q][:s].include?("master_default_price_amount")
          # PostgreSQL compatibility
          @stopped = @stopped.group("spree_prices.amount")
        end
        respond_with(@stopped)
      end

      protected

      def collection
        return @collection if @collection.present?
        params[:q] ||= {}
        params[:q][:deleted_at_null] ||= "1"
        params[:q][:sell_stop_false] ||= "1"
        params[:q][:sell_finish_at_gteq] ||= Time.now

        params[:q][:s] ||= "name asc"
        @collection = super
        @collection = @collection.with_deleted if params[:q].delete(:deleted_at_null).blank?
        # @search needs to be defined as this is passed to search_form_for
        @search = @collection.ransack(params[:q])
        @collection = @search.result.
          group_by_products_id.
          includes(product_includes).
          page(params[:page]).
          per(Spree::Config[:admin_products_per_page])

        if params[:q][:s].include?("master_default_price_amount")
          # PostgreSQL compatibility
          @collection = @collection.group("spree_prices.amount")
        end
        @collection
      end

    end
  end

