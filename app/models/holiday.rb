class Holiday < ActiveRecord::Base
  belongs_to :location
=begin
  validates :start_hr, :end_hr,
    :presence => true, :length => { :in => 1..2 },
    :numericality => { :only_integer => true, :less_than_or_equal_to => 23 }
  validates :start_min, :end_min,
    :presence => true, :length => { :in => 1..2 },
    :numericality => { :only_integer => true, :less_than_or_equal_to => 59 }
=end
  validates :day, :presence => true, :length => { :in => 1..250 }
  #validates_associated :location
=begin
  def self.is_holiday?
    where("#{self.day.day}#{self.day.month} = ?", "#{Time.now.day}#{Time.now.month}")
  end

  def self.within_service?(current_time)
    where(
      "((start_hr * 60) + start_min) <= ? AND
      ((end_hr * 60) + end_min) >= ?",
      current_time, current_time
    )
  end
=end
  def is_holiday?
    if all_day
      if "#{day.day}#{day.month}" == "#{Time.now.day}#{Time.now.month}"
        return true
      else
        return false
      end
    else
      return holiday_service
    end
  end

  def holiday_service
    start_in_min = (start_hr * 60) + start_min
    end_in_min = (end_hr * 60) + end_min
    current_time = (Time.now.hour * 60) + Time.now.min
    if day.day == Time.now.day
      if start_in_min <= current_time && end_in_min >= current_time
        return false
      else
        return true
      end
    else
      return false
    end
  end
end
