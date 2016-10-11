module Public::MenuSectionItemsHelper
  def time_in_minutes(time)
    min = time.min
    hour = time.hour
    return min + (hour * 60)
  end

  def served?(menu)
    current_time = time_in_minutes(Time.now)
    location = menu.location
    holidays = Holidays.where("location_id = ?", location.id)
    menu_hours = MenuHours.where("menu_id = ?", menu.id)
    if holidays
      holiday = holidays.is_holiday?
      if holiday && holiday.count > 0
        if holiday.all_day
          return false
        else
          holiday = holiday.within_service?(current_time)
          if holiday
            return false
          else
            return true
          end
        end
      else
        if menu_hours
          menu_hours = menu_hours.within_service?(current_time)
          if menu_hours && menu_hours.count > 0
            return true
          else
            return false
          end
        else
          return true
        end
      end
    else
      if menu_hours
        menu_hours = menu_hours.within_service?(current_time)
        if menu_hours && menu_hours.count > 0
          return true
        else
          return false
        end
      else
        return true
      end
    end
  end
end
