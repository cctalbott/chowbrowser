class Menu < ActiveRecord::Base
  belongs_to :location
  has_many :menu_sections, :dependent => :destroy
  has_many :menu_hours, :dependent => :destroy
  validates :name, :presence => true, :length => { :in => 1..150 }
  #validates_associated :menu_hours, :menu_sections, :location

  accepts_nested_attributes_for :menu_sections
  #accepts_nested_attributes_for :menu_hours, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :menu_hours, :allow_destroy => true

  def self.within_time?(current_time)
    where(
      "((menu_hours.menu_start_hour * 60) + menu_hours.menu_start_min) <= ? AND
      ((menu_hours.menu_end_hour * 60) + menu_hours.menu_end_min) >= ?",
      current_time, current_time
    )
  end

  def is_available?
    @serving = false
    @current_time = Time.now.min + (Time.now.hour * 60)
    @current_day = Time.now.days_to_week_start(:sunday)

    if location.restaurant_hours && location.restaurant_hours.length > 0
      location.restaurant_hours.each do |restaurant_hour|
        restaurant_day = restaurant_hour.day
        restaurant_start = (restaurant_hour.start_hr * 60) + restaurant_hour.start_min
        restaurant_end = (restaurant_hour.end_hr * 60) + restaurant_hour.end_min
        if restaurant_day == @current_day
          if(restaurant_start <= @current_time && restaurant_end >= @current_time)
            @serving = true
          end
        end
      end
      if @serving == true
        @serving = false
        if menu_hours && menu_hours.length > 0
          menu_hours.each do |menu_hour|
            menu_start = (menu_hour.menu_start_hour * 60) + menu_hour.menu_start_min
            menu_end = (menu_hour.menu_end_hour * 60) + menu_hour.menu_end_min
            if(menu_start <= @current_time && menu_end >= @current_time)
              @serving = true
            end
          end

          # new stuff here
          if @serving == true
            if location.on_holiday?
              @serving = false
            end
          end
        end
      end
    end

    return @serving
  end
end
