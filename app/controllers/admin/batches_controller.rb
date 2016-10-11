class Admin::BatchesController < AdminController
  #load_and_authorize_resource
  before_filter :can_view_batches

  def index
    @orders = Order.joins(:cart => {:line_items => {:menu_section_item => {:menu_section => {:menu => :location}}}}).purchased.group("orders.id, carts.purchased_at").order("carts.purchased_at DESC")
    @orders_by_day = @orders.group_by { |o| o.cart.purchased_at.strftime("%d %b %Y") }

    respond_to do |format|
      format.html
      #format.pdf
      #format.xml  { render :xml => @orders}
      #format.csv { render :csv => @orders}
    end
  end

  def drivers
    @orders = Order.joins(:cart => {:line_items => {:menu_section_item => {:menu_section => {:menu => :location}}}}).purchased.delivers.group("orders.id, carts.purchased_at").order("carts.purchased_at DESC")
    @orders_by_day = @orders.group_by { |o| o.cart.purchased_at.strftime("%d %b %Y") }

    respond_to do |format|
      format.html
      #format.pdf
      #format.xml  { render :xml => @orders}
      #format.csv { render :csv => @orders}
    end
  end

  def sales
    @orders = Order.joins(:cart => {:line_items => {:menu_section_item => {:menu_section => {:menu => :location}}}}).purchased.group("orders.id, carts.purchased_at").order("carts.purchased_at DESC")
    @orders_by_day = @orders.group_by { |o| o.cart.purchased_at.strftime("%d %b %Y") }

    respond_to do |format|
      format.html
      #format.pdf
      #format.xml  { render :xml => @orders}
      #format.csv { render :csv => @orders}
    end
  end

  private

    def can_view_batches
      unless can? :manage, Order
        redirect_to root_path
        return
      end
    end

    def sort_column
      Order.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def subtotal_total
      total = 0
      @orders.each do |order|
        total += order.subtotal
      end
      return total
    end

    def grand_total_total
      total = 0
      @orders.each do |order|
        total += order.grand_total
      end
      return total
    end

    def tips_total
      total = 0
      @orders.each do |order|
        total += order.tip.is_a?(Integer) ? order.tip : 0
      end
      total = (total > 0) ? number_to_currency(total) : "n/a"
      return total
    end

    def restaurant_total
      total = 0
      @orders.each do |order|
        total += order.restaurant_deposit
      end
      return total
    end

    def drivers_total
      total = 0
      @orders.each do |order|
        total += order.driver_deposit.is_a?(Integer) ? order.driver_deposit : 0
      end
      total = (total > 0) ? number_to_currency(total) : "n/a"
      return total
    end

    def chowbrowser_total
      total = 0
      @orders.each do |order|
        total += order.chowbrowser_deposit
      end
      return total
    end
end
