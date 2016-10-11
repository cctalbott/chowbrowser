module Admin::MenusHelper
  def served_from(menu_hours)
    output = ""
    menu_hours.each_with_index do |menu_hour, i|
      if(menu_hour.menu_start_hour.nil? || menu_hour.menu_start_min.nil? || menu_hour.menu_end_hour.nil? || menu_hour.menu_end_min.nil?)
        output += "Served daily"
      else
        menu_start = to_ampm(menu_hour.menu_start_hour, menu_hour.menu_start_min)
        menu_end = to_ampm(menu_hour.menu_end_hour, menu_hour.menu_end_min)
        if i > 0
          output += " and #{menu_start} to #{menu_end}"
        else
          output += "Served from #{menu_start} to #{menu_end}"
        end
      end
    end
    return output
  end
end
