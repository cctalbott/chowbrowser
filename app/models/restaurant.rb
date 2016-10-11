class Restaurant < ActiveRecord::Base
  has_one :logo, :dependent => :destroy
  has_many :locations, :dependent => :destroy
  has_many :menu_section_items, :dependent => :destroy
  has_many :sales_offices, :through => :locations
  has_many :users, :through => :locations
  has_and_belongs_to_many :cuisines
  accepts_nested_attributes_for :locations
  validates :name, :presence => true, :length => { :in => 1..250 }
  validates :description, :length => { :maximum => 500 }
  validates :report_email, :length => { :in => 1..140 }, :allow_blank => true,
    :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
  #validates_associated :locations, :menu_section_items

  def to_xml(options = {})
    #super(:only => [:name])
    options.merge!(:only => [:name])
    super(options)
  end

  def self.by_cuisine(id)
    Restaurant.joins(:cuisines).where("cuisines.id = ?", id)
  end

  def self.active
    joins(:locations).where("locations.active = ? AND restaurants.id != ?", true, 11)
  end

  def self.active_admin
    joins(:locations).where("locations.active = ?", true)
  end
end
