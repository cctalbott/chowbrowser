class PublicController < ApplicationController
  skip_before_filter :authenticate_user!
  before_filter :current_cart

  def current_cart
    controller = self.controller_path
    action = self.action_name

    if(controller == "public/menus" && action == "show" ||
      controller == "public/carts" ||
      controller == "public/line_items" ||
      controller == "public/orders" ||
      controller == "twilio" ||
      controller == "public/delivery_addresses")
      if session[:cart_id]
        if session[:cart_id].nil?
          @current_cart = Cart.create!
          session[:cart_id] = @current_cart.id
        else
          @current_cart ||= Cart.find(session[:cart_id])
          session[:cart_id] = @current_cart.id
        end
      else
        @current_cart = Cart.create!
        session[:cart_id] = @current_cart.id
      end
      session[:cart_id] = nil if @current_cart.purchased_at
      @cart = @current_cart
    else
=begin
      if session[:cart_id].nil?
        @current_cart = Cart.create!
        session[:cart_id] = @current_cart.id
        @cart = @current_cart
      end
=end
      unless Cart.where("id = ?", session[:cart_id]).length > 0
        session[:cart_id] = nil
      end

      if session[:cart_id]
        @current_cart ||= Cart.find(session[:cart_id])
        session[:cart_id] = nil if @current_cart.purchased_at
        @cart = @current_cart
      end

      if @cart
        #if @cart.line_items
        #  if @cart.line_items.count > 0
        session[:cart_id] = nil
        #unless @current_cart.purchased_at
        unless @current_cart.order
          @cart.destroy
        end
        #  end
        #end
        Cart.sweep
      end
    end
  end
end
