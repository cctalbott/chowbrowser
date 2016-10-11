class DeliveryHour < ActiveRecord::Base
  belongs_to :delivery_driver
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
    joins(:delivery_driver => {:locations => :menus}).select("day, start_hr, end_hr, start_min, end_min, menus.id").where("menus.id = ?", menu_id).where(:day => day).order("start_hr ASC, start_min ASC")
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
end
