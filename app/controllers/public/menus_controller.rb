class Public::MenusController < PublicController
  def index
  end

  def show
    @menu = Menu.find(params[:id])
    @menu_sections = @menu.menu_sections.order("position ASC, created_at ASC")
    @cart = current_cart
    if @menu.location.delivery_drivers && @menu.location.delivery_drivers.count > 0
      @delivery_days = DeliveryHour.joins(:delivery_driver => {:locations => :menus}).select("delivery_hours.day, menus.id").where("menus.id = ?", @menu.id).group("delivery_hours.day, menus.id").order("day ASC")
    end
  end
end
