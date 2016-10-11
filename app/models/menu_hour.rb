class MenuHour < ActiveRecord::Base
  belongs_to :menu
  validates :menu_start_hour, :menu_end_hour,
    :presence => true, :length => { :in => 1..2 },
    :numericality => { :only_integer => true, :less_than_or_equal_to => 23 }
  validates :menu_start_min, :menu_end_min,
    :presence => true, :length => { :in => 1..2 },
    :numericality => { :only_integer => true, :less_than_or_equal_to => 59 }
  #validates_associated :menu

  def self.within_service?(current_time)
    where(
      "((menu_start_hour * 60) + menu_start_min) <= ? AND
      ((menu_end_hour * 60) + menu_end_min) >= ?",
      current_time, current_time
    )
  end
end
