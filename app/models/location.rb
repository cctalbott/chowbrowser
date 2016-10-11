class Location < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :sales_office
  has_and_belongs_to_many :users
  has_and_belongs_to_many :delivery_drivers
  has_many :restaurant_hours, :dependent => :destroy
  has_many :holidays, :dependent => :destroy
  has_many :menus, :dependent => :destroy
  has_many :location_numbers, :dependent => :destroy
  has_one :delivery
  has_one :printer
  has_one :sales_person

  attr_accessor :delivers

  accepts_nested_attributes_for :restaurant_hours, :allow_destroy => true
  accepts_nested_attributes_for :holidays, :allow_destroy => true
  accepts_nested_attributes_for :delivery, :allow_destroy => true
  accepts_nested_attributes_for :location_numbers, :reject_if => :all_blank,
    :allow_destroy => true

  validates :address, :presence => true, :length => { :in => 1..250 }
  validates :region, :presence => true, :length => { :in => 1..100 }
  validates :city, :presence => true, :length => { :in => 1..150 }
=begin
  validates :phone, :presence => true, :length => { :in => 1..50 },
    :format => { :with => /^(1?(-?\d{3})-?)?(\d{3})(-?\d{4})$/ }
  validates :send_digits_ext, :length => { :in => 1..20 }, :allow_blank => true
  validates :txt_no, :length => { :in => 1..50 }, :allow_blank => true,
    :format => { :with => /^(1?(-?\d{3})-?)?(\d{3})(-?\d{4})$/ }
=end
  #validates_associated :restaurant, :restaurant_hours, :holidays, :menus
  validates_associated :delivery, :restaurant_hours, :holidays, :users,
    :location_numbers

  def full_address
    "#{self.address}, #{self.city}, #{self.region}"
  end

  def restaurant_name
    self.restaurant.name
  end

  def delivers
    if self.delivery
      return true
    else
      return false
    end
  end

  def self.delivers
    if delivery
      return true
    else
      return false
    end
  end

  def drivers_active?
    @delivering = false
    delivery_drivers.each do |delivery_driver|
      if delivery_driver.is_delivering?
        @delivering = true
      end
    end
    return @delivering
  end

  def delivery_fee
    delivery.fee
  end

  def main_phone_number
    @location_number = LocationNumber.where(:location_id => id, :main_number => true).first
    return @location_number.phone
  end

  def main_digits_ext
    @location_number = LocationNumber.where(:location_id => id, :main_number => true).first
    if @location_number.send_digits_ext
      ext_digits = @location_number.send_digits_ext
    end
    return ext_digits
  end

  def sends_digits_ext
    @location_numbers = LocationNumber.where(:location_id => id, :text_number => false)
    if !@location_numbers.first.send_digits_ext.blank?
      return true
    else
      return false
    end
  end

  def on_holiday?
    @holiday = false
    if holidays && holidays.length > 0
      holidays.each do |holiday|
        if holiday.is_holiday?
          @holiday = true
        end
      end
    end
    return @holiday
  end
end
