class Cuisine < ActiveRecord::Base
  has_and_belongs_to_many :restaurants
  validates :name, :presence => true, :length => { :in => 1..75 }
  validates_uniqueness_of :name
end
