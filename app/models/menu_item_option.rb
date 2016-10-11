class MenuItemOption < ActiveRecord::Base
  belongs_to :menu_section_item
  belongs_to :item_option_section
  has_many :line_item_options, :dependent => :destroy
  has_many :line_items, :through => :line_item_options
  validates :name, :presence => true, :length => { :in => 1..250 }
  validates :price, :presence => true, :length => { :in => 1..4 }, :numericality => true
  #validates_associated :menu_section_item, :item_option_section, :line_item_options, :line_items
end
