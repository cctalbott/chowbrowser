class OptionRelationship < ActiveRecord::Base
  belongs_to :menu_section_item
  belongs_to :item_option_section
  belongs_to :menu_section
end
