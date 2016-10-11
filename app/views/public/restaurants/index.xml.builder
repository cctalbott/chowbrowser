xml.instruct!
xml.Restaurants do
  @restaurants.each do |restaurant|
    xml.Restaurant do
      xml.id "#{restaurant.id}"
      xml.name "#{restaurant.name}"
      xml.description "#{restaurant.description}"
      xml.addressLine1 "#{restaurant.locations.first.address}"
      xml.addressLine2
      xml.city "#{restaurant.locations.first.city}"
      xml.state "#{restaurant.locations.first.region}"
      xml.zip "#{restaurant.locations.first.postal_code}"
      xml.phone "#{restaurant.locations.first.main_phone_number}"
      xml.lat "#{restaurant.locations.first.lat}"
      xml.lon "#{restaurant.locations.first.lon}"
      restaurant.cuisines.each do |cuisine|
        xml.category "#{cuisine.name}"
      end
      xml.hours do
        restaurant.locations.first.restaurant_hours.each do |restaurant_hour|
          xml.hour do
            xml.day "#{days_array[restaurant_hour.day][0].capitalize}"
            xml.hoursOpen "#{to_ampm(restaurant_hour.start_hr, restaurant_hour.start_min)} - #{to_ampm(restaurant_hour.end_hr, restaurant_hour.end_min)}"
          end
        end
      end
      current_menu = which_menu?(restaurant.locations.first.menus)
      if current_menu.nil?
        current_menu = restaurant.locations.first.menus.order("position ASC, created_at DESC").first
      end
      xml.menuURL "#{public_menu_url(current_menu.id)}"
    end
  end
end
