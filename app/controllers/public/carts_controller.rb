class Public::CartsController < PublicController
  load_and_authorize_resource

  def show
    #@cart = current_cart

    respond_to do |format|
      format.html
      format.js
    end
  end

  def delivery
    #@cart = current_cart
    @delivering = false
    if @cart.location.delivers
      @delivery_drivers = @cart.location.delivery_drivers
      @delivery_drivers.each do |delivery_driver|
        if delivery_driver.is_delivering?
          @delivering = true
        end
      end
      if user_signed_in?
        @last_order_delivery = Order.joins(:cart).by_customer(current_user.email).delivers.purchased.last
        @delivery_addresses = DeliveryAddress.joins(:carts => :order).select("MAX(delivery_addresses.id) AS da_id, address, city").where("orders.email = ?", current_user.email).group("address, city")
        if @last_order_delivery
          @cart.update_attribute(:delivery_address_id, @last_order_delivery.delivery_address.id)
        else
          @cart.build_delivery_address
        end
      else
        @cart.build_delivery_address
      end
    end
    unless @cart.location.delivers && @delivering
      redirect_to new_public_order_path
      return
    end
  end

  def update_delivery
    #@cart = current_cart
    @cart.update_attribute(:delivers, params[:cart][:delivers])
    if @cart.delivery_address_id.blank? || @cart.delivery_address_id.nil?
      @cart.build_delivery_address(params[:cart][:delivery_address_attributes])
      @cart.save
    end
    redirect_to public_cart_tip_path
  end

  def tip
    #@cart = current_cart
    unless @cart.delivers
      redirect_to new_public_order_path
      return
    end
  end

  def update_tip
    #@cart = current_cart
    if params[:cart][:tip]
      @cart.update_attribute(:tip, params[:cart][:tip])
    end
    redirect_to new_public_order_path
  end
end
