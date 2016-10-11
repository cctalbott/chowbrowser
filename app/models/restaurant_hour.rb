class RestaurantHour < ActiveRecord::Base
  belongs_to :location
  #validates_associated :location
  validates :start_hr, :end_hr,
    :presence => true, :length => { :in => 1..2 },
    :numericality => { :only_integer => true, :less_than_or_equal_to => 23 }
  validates :start_min, :end_min,
    :presence => true, :length => { :in => 1..2 },
    :numericality => { :only_integer => true, :less_than_or_equal_to => 59 }
  validates :day,
    :presence => true, :length => { :is => 1 },
    :numericality => { :only_integer => true, :less_than_or_equal_to => 6 }

  def self.hours_by_day_and_menu(menu_id, day)
    joins(:location => :menus).select("day, start_hr, end_hr, start_min, end_min, menus.id").where("menus.id = ?", menu_id).where(:day => day).order("start_hr ASC, start_min ASC")
  end

  def self.location_delivery_hours(location_id, day)
    @hours_array = []
    @hours = joins(:location => {:delivery_drivers => :delivery_hours}).select("restaurant_hours.id, restaurant_hours.location_id, delivery_hours.id, restaurant_hours.day AS lhday, restaurant_hours.start_hr AS lhsh, restaurant_hours.start_min AS lhsm, restaurant_hours.end_hr AS lheh, restaurant_hours.end_min AS lhem, delivery_hours.day AS dhday, delivery_hours.start_hr AS dhsh, delivery_hours.start_min AS dhsm, delivery_hours.end_hr AS dheh, delivery_hours.end_min AS dhem").where(:location_id => location_id).where("restaurant_hours.day = ?", day).where("delivery_hours.day = ?", day).group("restaurant_hours.id, restaurant_hours.location_id, delivery_hours.id, restaurant_hours.day, restaurant_hours.start_hr, restaurant_hours.start_min, restaurant_hours.end_hr, restaurant_hours.end_min, delivery_hours.day, delivery_hours.start_hr, delivery_hours.start_min, delivery_hours.end_hr, delivery_hours.end_min").order("restaurant_hours.day ASC, delivery_hours.day ASC, restaurant_hours.start_hr ASC, delivery_hours.start_hr ASC")
    @hours.each do |hour|
      lhsh = hour.lhsh.to_i
      dhsh = hour.dhsh.to_i
      lheh = hour.lheh.to_i
      dheh = hour.dheh.to_i
      lhsm = hour.lhsm.to_i
      dhsm = hour.dhsm.to_i
      lhem = hour.lhem.to_i
      dhem = hour.dhem.to_i
      if lhsh <= dhsh && lheh >= dhsh
        adhsh = dhsh
        adheh = (lheh <= dheh) ? lheh : dheh
        if lhsh == dhsh
          adhsm = (lhsm >= dhsm) ? lhsm : dhsm
        else
          adhsm = dhsm
        end
        if lheh == dheh
          adhem = (lhem <= dhem) ? lhem : dhem
        else
          adhem = dhsm
        end
      elsif lheh >= dheh && lhsh <= dheh
        adhsh = (lhsh >= dhsh) ? lhsh : dhsh
        adheh = dheh
        if lhsh == dhsh
          adhsm = (lhsm >= dhsm) ? lhsm : dhsm
        else
          adhsm = dhsm
        end
        if lheh == dheh
          adhem = (lhem <= dhem) ? lhem : dhem
        else
          adhem = dhsm
        end
      else
        adhsh = nil
        adhsm = nil
        adheh = nil
        adhem = nil
      end
      if adhsh && adhsm && adheh && adhem
        @hours_array.push("#{to_ampm(adhsh, adhsm)} to #{to_ampm(adheh, adhem)}")
      end
    end
    @hours_array = @hours_array.uniq
    return @hours_array
  end

  def start_time_formatted
    "#{start_hr}:#{sprintf '%02d', start_min}"
  end

  def end_time_formatted
    "#{end_hr}:#{sprintf '%02d', end_min}"
  end

  def start_in_seconds
    (start_hr * 60) + start_min
  end

  def end_in_seconds
    (end_hr * 60) + end_min
  end

  private

  def self.to_ampm(hr, min)
    if hr < 12
      if hr == 0
        hr = 12
      else
        hr = hr
      end
      ampm = "am"
    else
      if hr == 12
        hr = hr
      else
        hr = hr - 12
      end
      ampm = "pm"
    end
    formatted_time = "#{hr}:#{'%02d' % min}#{ampm}"
    return formatted_time
  end
end
