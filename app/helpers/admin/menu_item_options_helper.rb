module Admin::MenuItemOptionsHelper
  def add_option_sections
    menu_section_items = MenuSectionItem.all
  
    for item in menu_section_items do
      if item.menu_item_options
        unless item.item_option_sections
          item_option_section = ItemOptionSection.new(:name => "Size", :position => 0)
          item_option_section.save
          for option in item.menu_item_options do
            option.item_option_section = option.menu_section_item.item_option_sections.first
            option.save
          end
        end
      end
    end
  end
end