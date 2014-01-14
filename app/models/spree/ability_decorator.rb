module Spree
    Ability.class_eval do

  def initialize(user)
      self.clear_aliased_actions

      # override cancan default aliasing (we don't want to differentiate between read and index)
      alias_action :delete, to: :destroy
      alias_action :edit, to: :update
      alias_action :new, to: :create
      alias_action :new_action, to: :create
      alias_action :show, to: :read

      user ||= Spree.user_class.new

      if user.respond_to?(:has_spree_role?) && user.has_spree_role?('admin')
        can :manage, :all
      elsif user.respond_to?(:has_spree_role?) && user.has_spree_role?('user')
        can [:index, :read], Country
        can [:index, :read], OptionType
        can [:index, :read], OptionValue

        can :manage, Order

        can :create, Order
        can :read, Order do |order, token|
          order.user == user || order.token && token == order.token
        end
        can :update, Order do |order, token|
          order.user == user || order.token && token == order.token
        end

        can :manage, Product, user_id: user.id
        can [:sell_stop, :finished], Product, user_id: user.id
        can [:new, :create], Product

        can :manage, Question, user_id: user.id
        can :manage, Answer

        can :manage, Variant
        can :manage, ProductProperty
        can :manage, Image

        can [:index, :read], Property
        can :create, Spree.user_class
        can [:read, :update, :destroy], Spree.user_class, id: user.id
        can [:index, :read], State
        can [:index, :read], StockItem
        can [:index, :read], StockLocation
        can [:index, :read], StockMovement
        can [:index, :read], Taxon
        can [:index, :read], Taxonomy
        can [:index, :read], Zone
      else
        can :read, Question
        can [:index, :read], Country
        can [:index, :read], OptionType
        can [:index, :read], OptionValue
        can :create, Order
        can :read, Order do |order, token|
          order.user == user || order.token && token == order.token
        end
        can :update, Order do |order, token|
          order.user == user || order.token && token == order.token
        end
        can [:index, :read], Product
        can [:index, :read], ProductProperty
        can [:index, :read], Property
        can :create, Spree.user_class
        can [:read, :update, :destroy], Spree.user_class, id: user.id
        can [:index, :read], State
        can [:index, :read], StockItem
        can [:index, :read], StockLocation
        can [:index, :read], StockMovement
        can [:index, :read], Taxon
        can [:index, :read], Taxonomy
        can [:index, :read], Variant
        can [:index, :read], Zone
      end

      # Include any abilities registered by extensions, etc.
      Ability.abilities.each do |clazz|
        ability = clazz.send(:new, user)
        @rules = rules + ability.send(:rules)
      end
    end

  end
end
