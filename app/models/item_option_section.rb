class ItemOptionSection < ActiveRecord::Base
  belongs_to :menu_section_item
  #has_many :line_item_options, :dependent => :destroy
  #has_many :line_items, :through => :line_item_options
  has_many :menu_item_options, :dependent => :destroy

  has_many :option_relationships
  has_many :menu_sections, :through => :option_relationships
  has_many :menu_section_items, :through => :option_relationships

  validates :name, :presence => true, :length => { :in => 1..250 }
  #validates_associated :menu_section_item, :menu_item_options

  def self.by_menu(menu)
    joins(:option_relationships => {:menu_section_item => {:menu_section => :menu}}).where("menus.id = ?", menu)
  end
=begin
  def self.grouped_option_sections(menu)
    @ios_by_menu = by_menu(menu)
    @ios_by_menu
  end
=end
end
