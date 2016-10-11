class DeliveryAddress < ActiveRecord::Base
  #belongs_to :order
  has_many :carts
  has_many :orders, :through => :carts
  validates :address, :city, :zip, :presence => true
  validates :address, :city, :length => { :in => 1..250 }
  validates :zip, :length => { :in => 1..100 }
  attr_accessor :full_address

  def self.full_address
    full_address
  end

  def full_address
    "#{address}, #{city}, TX"
  end
end
