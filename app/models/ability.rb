class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

    #alias_action :sms, :make_call, :hellomoto, :directions, :goodbye, :to => :twilio
    alias_action :delivery, :update_delivery, :tip, :update_tip, :to => :manage_cart
    alias_action :success, :failure, :status_update, :to => :manage_order
    alias_action :restaurant_index, :customer_index, :to => :view_order_reporting
    alias_action :incomplete_orders, :to => :admin_orders
    alias_action :distance, :to => :get_delivery_address

    user ||= User.new({:role => "guest"}) # guest user (not logged in)
    #unless user.role.exists?
    #  user.role = "guest"
    #end

    if user.role? :admin
      can :manage, :all
      #can :twilio, Twilio
    elsif user.role? :editor
      can [:create, :destroy], ClockIn
      customer_guest
    elsif user.role? :restaurant_owner
      #can :read, Order do |order|
      #  order.restaurant_name
      #end
      can :manage_cart, Cart
      restaurants
    elsif user.role? :restaurant_editor
      restaurants
    elsif user.role? :customer
      can [:update, :read], User
      can :get_delivery_address, DeliveryAddress
      customer_guest
    elsif user.role? :guest
      # uncomment for production
      #can [:create, :read], User
      customer_guest
    else

    end
  end

  private

    def restaurants
      #can :read, Order, :restaurant => { :id => user. }
      can :view_order_reporting, Order
      can [:create, :destroy], ClockIn
      customer_guest
    end

    def customer_guest
      can :read, [
        Cart,
        LineItem, Location,
        Menu, MenuHour, MenuItemOption, MenuSection, MenuSectionItem,
        Order,
        Restaurant
      ]
      can :create, [LineItem, Order]
      can :select, MenuItemOption
      can [:update, :destroy, :destroy_option], LineItem
      can :destroy, LineItemOption
      can :manage_cart, Cart
      can :manage_order, Order

      # only for dev
      #can :manage, User
    end
end
