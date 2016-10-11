class MenuSection < ActiveRecord::Base
  belongs_to :menu
  has_many :menu_section_items, :dependent => :destroy

  has_many :option_relationships
  has_many :item_option_sections, :through => :option_relationships

  validates :name, :presence => true, :length => { :in => 1..250 }
  validates :description, :length => { :maximum => 500 }
  #validates_associated :menu, :menu_section_items
  accepts_nested_attributes_for :menu_section_items
end
