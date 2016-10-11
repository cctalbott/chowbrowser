module MenusHelper
  def time_in_minutes(time)
    min = time.min
    hour = time.hour
    return min + (hour * 60)
  end

  def menu_available?(menus)
    current_time = time_in_minutes(Time.now)
    menu = Menu.joins(:menu_hours).where("menus.id IN (?)", menus).within_time?(current_time)
    if menu
      menu = menu.order("menus.position DESC, menus.created_at ASC")
    end
    return menu
  end

  def menu_time_set?(menus)
    current_time = time_in_minutes(Time.now)
    menu = Menu.joins(:menu_hours).where("menus.id IN (?) AND menu_hours.menu_start_hour = ?",
      menus, nil).
      order("menus.position DESC, menus.created_at ASC")
    return menu
  end

  def served_from(menu_hours)
    output = ""
    menu_hours.each_with_index do |menu_hour, i|
      if(menu_hour.menu_start_hour.nil? || menu_hour.menu_start_min.nil? || menu_hour.menu_end_hour.nil? || menu_hour.menu_end_min.nil?)
        output += "serves daily"
      else
        menu_start = to_ampm(menu_hour.menu_start_hour, menu_hour.menu_start_min)
        menu_end = to_ampm(menu_hour.menu_end_hour, menu_hour.menu_end_min)
        if i > 0
          output += " and #{menu_start} to #{menu_end}"
        else
          output += "serves from #{menu_start} to #{menu_end}"
        end
      end
    end
    return output
  end
end
