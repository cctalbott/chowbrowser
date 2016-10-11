class SalesOffice < ActiveRecord::Base
  has_many :locations
  has_many :restaurants, :through => :locations
  has_many :users, :through => :locations

  #accepts_nested_attributes_for :restaurant_hours, :allow_destroy => true
  #accepts_nested_attributes_for :holidays, :allow_destroy => true

  validates :name, :presence => true, :length => { :in => 1..150 }
  validates :location, :presence => true, :length => { :in => 1..150 }
  #validates_associated :restaurant, :restaurant_hours, :holidays, :menus
end
