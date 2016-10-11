class MenuSectionItem < ActiveRecord::Base
  belongs_to :menu_section
  belongs_to :menu
  has_many :menu_item_options, :dependent => :destroy
  #has_many :item_option_sections, :dependent => :destroy

  has_many :option_relationships
  has_many :item_option_sections, :through => :option_relationships

  validates :name, :presence => true, :length => { :in => 1..200 }
  validates :description, :length => { :maximum => 500 }
  validates :price, :presence => true, :length => { :in => 1..5 }, :numericality => true
  validates_associated :menu_section, :menu, :menu_item_options, :item_option_sections
  accepts_nested_attributes_for :menu_item_options

  #def menu
  #  menu_section.menu
  #end

  def location
    menu_section.menu.location
  end
end
