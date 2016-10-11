require 'test_helper'

class MenuItemOptionTest < ActiveSupport::TestCase
  test "should not save menu item option without name and price" do
    menu_item_option = MenuItemOption.new
    assert !menu_item_option.save
  end

  test "should not save menu item option if name and price are less than 1 character" do
    menu_item_option = MenuItemOption.new({:name => "", :price => ""})
    assert !menu_item_option.save
  end

  test "should not save menu item option if name is valid but price is more than 4 characters" do
    menu_item_option = MenuItemOption.new(:name => "medium", :price => 100.23)
    assert !menu_item_option.save
  end

  test "should save menu item option if name and price are valid" do
    menu_item_option = MenuItemOption.new(:name => "medium", :price => 1.23)
    assert menu_item_option.save
  end
end
