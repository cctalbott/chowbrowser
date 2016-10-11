require 'test_helper'

class MenuSectionItemTest < ActiveSupport::TestCase
  test "should not save menu section item without name and price" do
    menu_section_item = MenuSectionItem.new
    assert !menu_section_item.save
  end
  
  test "should not save menu section item if name and price are less than 1 character" do
    menu_section_item = MenuSectionItem.new({:name => "", :price => ""})
    assert !menu_section_item.save
  end
  
  test "should save menu section item if name and price are valid" do
    menu_section_item = MenuSectionItem.new(:name => "carrots", :price => 1.23)
    assert menu_section_item.save
  end
  
  test "should save menu section item if name is valid but price is more than 5 characters" do
    menu_section_item = MenuSectionItem.new(:name => "carrots", :price => 1000.23)
    assert !menu_section_item.save
  end
end
