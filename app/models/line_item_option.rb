class LineItemOption < ActiveRecord::Base
  belongs_to :line_item
  belongs_to :menu_item_option

  validates :menu_item_option_id, :presence => true
  #validates_associated :line_item, :menu_item_option
end
