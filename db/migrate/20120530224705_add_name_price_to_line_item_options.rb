class AddNamePriceToLineItemOptions < ActiveRecord::Migration
  def change
    add_column :line_items, :name, :string, :limit => 200

    add_column :line_item_options, :name, :string
    add_column :line_item_options, :price, :float, :limit => 4

    @line_items = LineItem.all
    @line_item_options = LineItemOption.all

    @line_items.each do |line_item|
      menu_section_item = line_item.menu_section_item
      if menu_section_item
        line_item.update_attributes({:name => menu_section_item.name})
      end
    end

    @line_item_options.each do |line_item_option|
      menu_item_option = line_item_option.menu_item_option
      if menu_item_option
        line_item_option.update_attributes({:name => menu_item_option.name, :price => menu_item_option.price})
      end
    end
  end
end
