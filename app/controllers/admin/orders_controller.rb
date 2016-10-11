class Admin::OrdersController < AdminController
  load_and_authorize_resource
  helper_method :sort_column, :sort_direction
  before_filter :get_params, :only => [:index, :restaurant_index, :customer_index]

  def index
    if current_user.role?(:admin)
      @purchased_collection = Order.year_collection.order("purchased_at_year ASC")
      if @year == "all"
        @orders = Order.joins(:cart).purchased.order("purchased_at DESC")
      else
        if @month == "all"
          @orders = Order.joins(:cart).by_year(@year).order("purchased_at DESC")
        else
          @orders = Order.joins(:cart).by_month_and_year(@month, @year).order("purchased_at DESC")
          if @day == "all"
            @orders = Order.joins(:cart).by_month_and_year(@month, @year).order("purchased_at DESC")
          else
            @orders = Order.joins(:cart).by_day(@month, @year, @day).order("purchased_at DESC")
          end
          @purchased_day_collection = Order.day_collection(@month, @year).order("purchased_at_day ASC")
        end
        @purchased_month_collection = Order.month_collection(@year).order("purchased_at_month ASC")
      end
      @order_months = @orders.group_by { |o| o.cart.purchased_at.beginning_of_month }
    elsif current_user.role?(:restaurant_owner) || current_user.role?(:restaurant_editor)
      @user_restaurants = current_user.restaurants
      @user_restaurants_ids = @user_restaurants.collect {|ursids| ursids.id}
      @purchased_collection = Order.select("DISTINCT extract(year from carts.purchased_at) AS
        purchased_at_year").restaurants_join(@user_restaurants_ids).purchased.order("purchased_at_year ASC")
      if @year == "all"
        @orders = Order.restaurants_join(@user_restaurants_ids).purchased.order("purchased_at DESC")
      else
        if @month == "all"
          @orders = Order.restaurants_join(@user_restaurants_ids).by_year(@year).order("purchased_at DESC")
        else
          @orders = Order.restaurants_join(@user_restaurants_ids).by_month_and_year(@month, @year).order("purchased_at DESC")
          if @day == "all"
            @orders = Order.restaurants_join(@user_restaurants_ids).by_month_and_year(@month, @year).order("purchased_at DESC")
          else
            @orders = Order.restaurants_join(@user_restaurants_ids).by_day(@month, @year, @day).order("purchased_at DESC")
          end
          @purchased_day_collection = Order.restaurants_join(@user_restaurants_ids).day_collection(@month, @year).order("purchased_at_day ASC")
        end
        @purchased_month_collection = Order.restaurants_join(@user_restaurants_ids).month_collection(@year).order("purchased_at_month ASC")
      end
      @order_months = @orders.group_by { |o| o.cart.purchased_at.beginning_of_month }
    else
      redirect_to root_path
      return
    end
    respond_to do |format|
      format.html
      format.pdf
      format.xml  { render :xml => @orders}
      format.csv { render :csv => @orders}
    end
  end

  def incomplete_orders
    @orders = Order.joins(:cart).where("carts.purchased_at IS NULL OR status NOT IN (?, ?)", "confirmed", "delivering").readonly(false)
  end

  def complete_orders
    @orders = Order.joins(:cart).purchased.where(:status => ["confirmed", "delivering"]).order("carts.purchased_at DESC")
  end

  def update_status
    @order = Order.find(params[:id])
    @order_status_collection = [
      ["placed", "placed"],
      ["unconfirmed", "unconfirmed"],
      ["confirmed", "confirmed"],
      ["delivering", "delivering"]
    ]
    @location = Location.find(@order.location.id)
    @delivery_drivers_array = @location.delivery_drivers.map { |dd| dd.id }
    @delivery_drivers = DeliveryDriver.where(:id => @delivery_drivers_array)
  end

  def update
    @order = Order.find(params[:id])

    if @order.update_attributes(params[:order])
      redirect_to admin_order_path, :notice => "Order status updated."
    else
      redirect_to admin_update_order_status_path(@orders), :alert => "Order status update failed."
    end
  end

  def restaurant_index
    @restaurant = Restaurant.find(params[:restaurant]).name
    if current_user.role?(:admin) || current_user.role?(:restaurant_owner) || current_user.role?(:restaurant_editor)
      @restaurant_collection = Order.restaurant_collection(@month, @year).uniq
      @purchased_collection = Order.year_collection(@restaurant).order("purchased_at_year ASC")
      unless @year == "all"
        @purchased_month_collection = Order.month_collection(@year, @restaurant).order("purchased_at_month ASC")
        unless @month == "all"
          @purchased_day_collection = Order.day_collection(@month, @year, @restaurant).order("purchased_at_day ASC")
        end
      end
      @orders = Order.purchased_at_restaurant(@month, @year, @restaurant).order("carts.purchased_at DESC")
    else
      redirect_to root_path
      return
    end

    respond_to do |format|
      format.html
      format.pdf
      format.xml  { render :xml => @orders}
      format.csv { render :csv => @orders}
    end
  end

  def customer_index
    @customer = Order.find(params[:customer]).email
    if current_user.role?(:admin) || current_user.role?(:restaurant_owner) || current_user.role?(:restaurant_editor)
      @customer_collection = Order.customer_collection(@month, @year).index_by { |r| r[:email] }.values
      @purchased_collection = Order.year_collection(nil, @customer).order("purchased_at_year ASC")
      unless @year == "all"
        @purchased_month_collection = Order.month_collection(@year, nil, @customer).order("purchased_at_month ASC")
        unless @month == "all"
          @purchased_day_collection = Order.day_collection(@month, @year, @restaurant).order("purchased_at_day ASC")
        end
      end
      @orders = Order.purchased_by_customer(@customer, @month, @year).order("carts.purchased_at DESC")
    else
      redirect_to root_path
      return
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

    def sort_column
      #column_names = Order.column_names
      #column_names.push("restaurant_name", "price")
      Order.column_names.include?(params[:sort]) ? params[:sort] : "id"
      #column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
