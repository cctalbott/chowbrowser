module RestaurantsHelper
  def time_in_minutes(time)
    min = time.min
    hour = time.hour
    return min + (hour * 60)
  end

  def which_menu?(menus)
    current_time = time_in_minutes(Time.now)

    menu = Menu.joins(:menu_hours).where("menus.id IN (?)", menus).within_time?(current_time)
    if menu
      menu = menu.order("menus.position DESC, menus.created_at ASC").first 
    end
    return menu
  end
end
