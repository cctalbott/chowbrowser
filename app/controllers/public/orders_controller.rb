require 'twilio-ruby'

class Public::OrdersController < PublicController
  include ActionView::Helpers::TextHelper
  load_and_authorize_resource :except => [:status_update]
  helper_method :sort_column, :sort_direction
  before_filter :get_params, :only => [:index, :restaurant_index, :customer_index]
  before_filter :current_email, :only => [:index, :restaurant_index, :customer_index, :show]
  skip_before_filter :authenticate_user!, :only => [:success, :failure, :status_update]

  def index
    if can? :read, Order
      @purchased_collection = Order.year_collection.by_customer(@current_email).order("purchased_at_year ASC")
      if @year == "all"
        @orders = Order.joins(:cart).purchased.by_customer(@current_email).order(sort_column + " " + sort_direction + ", purchased_at ASC")
      else
        if @month == "all"
          @orders = Order.joins(:cart).by_year(@year).by_customer(@current_email).order(sort_column + " " + sort_direction + ", purchased_at ASC")
        else
          @orders = Order.joins(:cart).by_month_and_year(@month, @year).by_customer(@current_email).order(sort_column + " " + sort_direction + ", purchased_at ASC")
          if @day == "all"
            @orders = Order.joins(:cart).by_month_and_year(@month, @year).by_customer(@current_email).order(sort_column + " " + sort_direction + ", purchased_at ASC")
          else
            @orders = Order.joins(:cart).by_day(@month, @year, @day).by_customer(@current_email).order(sort_column + " " + sort_direction + ", purchased_at ASC")
          end
          @purchased_day_collection = Order.day_collection(@month, @year).by_customer(@current_email).order("purchased_at_day ASC")
        end
        @purchased_month_collection = Order.month_collection(@year).by_customer(@current_email).order("purchased_at_month ASC")
      end
      @order_months = @orders.group_by { |o| o.cart.purchased_at.beginning_of_month }
    else
      redirect_to root_path
      return
    end
    respond_to do |format|
      format.html
      format.pdf
      format.xml  { render :xml => @orders }
      format.csv
    end
  end

  def restaurant_index
    #@category = "restaurant"
    @restaurant = Restaurant.find(params[:restaurant]).name
    if can? :read, Order
      @restaurant_collection = Order.restaurant_collection(@month, @year).by_customer(@current_email).uniq
      @purchased_collection = Order.year_collection(@restaurant).by_customer(@current_email).order("purchased_at_year ASC")
      unless @year == "all"
        @purchased_month_collection = Order.month_collection(@year, @restaurant).by_customer(@current_email).order("purchased_at_month ASC")
        unless @month == "all"
          @purchased_day_collection = Order.day_collection(@month, @year, @restaurant).by_customer(@current_email).order("purchased_at_day ASC")
        end
      end
      @orders = Order.purchased_at_restaurant(@month, @year, @restaurant).by_customer(@current_email).order("carts.purchased_at ASC")
    else
      redirect_to root_path
    end
    respond_to do |format|
      format.html
      format.pdf
      format.xml  { render :xml => @orders }
      format.csv
    end
  end

  def customer_index
    #@category = "customer"
    @customer = @current_email
    if can? :manage, Order
      @customer_collection = Order.customer_collection(@month, @year).by_customer(@customer).index_by { |r| r[:email] }.values
      @purchased_collection = Order.year_collection(nil, @customer).order("purchased_at_year ASC")
      unless @year == "all"
        @purchased_month_collection = Order.month_collection(@year, nil, @customer).order("purchased_at_month ASC")
        unless @month == "all"
          @purchased_day_collection = Order.day_collection(@month, @year, @restaurant).order("purchased_at_day ASC")
        end
      end
      @orders = Order.purchased_by_customer(@customer, @month, @year).order("carts.purchased_at ASC")
    else
      redirect_to root_path
    end
    respond_to do |format|
      format.html
      format.pdf
      format.xml  { render :xml => @orders }
      format.csv
    end
  end

  def show
    if can? :read, Order
      @order = Order.find(params[:id])
      @first_line_item = @order.cart.line_items.first
    end

    respond_to do |format|
      format.html { render :layout => "order_detail" }
      format.pdf
      format.xml  { render :xml => @order }
      format.csv
    end
  end

  def new
    @order = Order.new
    if user_signed_in?
      @order.email = current_user.email
      @last_order = Order.joins(:cart).by_customer(current_user.email).purchased.last
      if @last_order
        @order.phone = @last_order.phone
        @order.notify_method = @last_order.notify_method
        @order.card_type = @last_order.card_type
        @order.card_expires_on = @last_order.card_expires_on
        @order.build_billing_address(
          :address => @last_order.billing_address.address,
          :city => @last_order.billing_address.city,
          :state => @last_order.billing_address.state,
          :country => @last_order.billing_address.country,
          :zip => @last_order.billing_address.zip,
          :first_name => @last_order.billing_address.first_name,
          :last_name => @last_order.billing_address.last_name
        )
        if @cart.delivers
=begin
          @last_order_delivery = Order.joins(:cart).by_customer(current_user.email).delivers.purchased.last
          #@delivery_addresses = DeliveryAddress.joins(:cart => :order).select("MAX(delivery_addresses.id) AS da_id, address, city").where("orders.email = ?", current_user.email).group("address, city")
          if @last_order_delivery
            @cart.update_attribute(:delivery_address_id, @last_order_delivery.delivery_address.id)
          end
=end
=begin
          @delivery_addresses = DeliveryAddress.joins(:order).select("MAX(delivery_addresses.id) AS da_id, address, city").where("orders.email = ?", current_user.email).group("address, city")
          if @last_order_delivery
            @order.build_delivery_address(
              :address => @last_order_delivery.delivery_address.address,
              :city => @last_order_delivery.delivery_address.city,
              :state => @last_order_delivery.delivery_address.state,
              :country => @last_order_delivery.delivery_address.country,
              :zip => @last_order_delivery.delivery_address.zip
            )
          else
            @order.build_delivery_address
          end
=end
        end
      else
        new_addresses
      end
    else
      new_addresses
    end
  end

  def create
    numbers_helper = Object.new.extend(ActionView::Helpers::NumberHelper)
    params[:order][:phone] = numbers_helper.number_to_phone(params[:order][:phone].gsub(/\D/, ''))
    @order = current_cart.build_order(params[:order])
    @order.ip_address = request.remote_ip
    @order.restaurant_name = @order.restaurant.name
    id_chars = [(1..9)].map{|i| i.to_a}.flatten
    identification_no = (0..4).map{id_chars[rand(id_chars.length)]}.join
    @order.identification_no = identification_no
    #if User.find(current_user)
    #  @order.user_id = current_user.id
    #else
    #  @order.user_id = nil
    #end
    if @order.save
      if @order.authorize
      #if @order.purchase
        #Order.delay.purchase(@order.id)
        #@order.delay.purchase
        unless Rails.env == "development"
          notify_restaurant
        end
        #redirect_to :action => "success?id=#{@order.id}"
        redirect_to public_order_success_path(:id => @order.id)
      else
        render :action => "failure"
      end
    else
      render :action => 'new'
    end
  end

  def success
    @order = Order.find(params[:id])
    #Order.delay.purchase(@order.id)
    #Order.purchase(@order.id)
    @first_line_item_location = @order.cart.line_items.first.menu_section_item.menu_section.menu.location
    if Rails.env == "development"
      @order.purchase
    end
  end

  def failure
    #
  end

  def status_update
    @order = Order.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  private

    def get_params
      @year = params[:year] ? params[:year] : "all"
      @month = params[:month] ? params[:month] : "all"
      @day = params[:day] ? params[:day] : "all"
      @category = params[:category] ? params[:category] : "all"
      @category_collection = {
        :all => "all",
        :restaurant => "restaurant",
        :customer => "customer"
      }
    end

    def current_email
      @current_email = current_user ? current_user.email : ""
    end

    def sort_column
      #column_names = Order.column_names
      #column_names.push("restaurant_name", "price")
      Order.column_names.include?(params[:sort]) ? params[:sort] : "id"
      #column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def notify_restaurant
      #Order.delay.purchase(@order.id)
      @order.purchase
      @order.cart.update_attribute(:purchased_at, Time.now)
      #if @order.cart.location.printer
      #  PrintMailer.order_confirmation(@order).deliver
      #end
      PrintMailer.order_confirmation(@order).deliver
      if @order.location.recite_order
        @call_url = BASE_URL + "/order_placed_recite.xml?order=#{@order.id}"
      else
        @call_url = BASE_URL + "/order_placed.xml?order=#{@order.id}"
      end
      if @order.text_location && @order.text_location.length > 0
        @order.text_location.each do |location_text|
          text_restaurant(location_text.phone)
        end
      end
      if !@order.location.location_numbers.where(:main_number => true).first.send_digits_ext.blank?
        data = {
          'From' => CALLER_ID,
          'To' => @order.location.main_phone_number,
          'SendDigits' => @order.location.location_numbers.where(:main_number => true).first.send_digits_ext,
          'Url' => @call_url,
          'StatusCallback' => BASE_URL + "/restaurant_status?order=#{@order.id}",
          'FallbackUrl' => BASE_URL + "/error.xml?order=#{@order.id}"
        }
      else
        data = {
          'From' => CALLER_ID,
          'To' => @order.location.main_phone_number,
          'Url' => @call_url,
          'StatusCallback' => BASE_URL + "/restaurant_status?order=#{@order.id}",
          'FallbackUrl' => BASE_URL + "/error.xml?order=#{@order.id}"
        }
      end
      begin
        client = Twilio::REST::Client.new(ACCOUNT_SID, AUTH_TOKEN)
        client.account.calls.create data
      rescue StandardError => bang
        redirect_to BASE_URL + "/error.xml?order=#{@order.id}", :alert => "Error #{bang}"
        #redirect_to public_order_failure_path, :alert => "Error #{bang}"
        return
      end
    end

    def text_restaurant(location_text_number)
      @order_description = "Order placed for #{@order.billing_address.first_name} #{@order.billing_address.last_name} through ChowBrowser. Estimated Wait: #{@order.total_wait}."
=begin
      @order.cart.line_items.each do |line_item|
        @order_description += "#{line_item.quantity} #{line_item.menu_section_item.name} "
        if line_item.menu_item_options && line_item.menu_item_options.length > 0
          @order_description += "("
          line_item.menu_item_options.each do |menu_item_option|
            @order_description += "#{menu_item_option.name} "
          end
          @order_description += ")"
        end
      end
=end
      @client = Twilio::REST::Client.new(ACCOUNT_SID, AUTH_TOKEN)
      @account = @client.account
      @message = @account.sms.messages.create({:from => '555-555-5555',
        :to => "#{location_text_number}",
        :body => truncate(@order_description, :length => 155)})
      puts @message
    end

    def new_addresses
      @order.build_billing_address
=begin
      if @cart.delivers
        @order.build_delivery_address
      end
=end
    end
end
