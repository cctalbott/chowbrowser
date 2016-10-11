require 'test_helper'

class MenuSectionTest < ActiveSupport::TestCase
  test "should not save menu section without name" do
    menu_section = MenuSection.new
    assert !menu_section.save
  end
  
  test "should not save menu section if name is less than 1 character" do
    menu_section = MenuSection.new({:name => ""})
    assert !menu_section.save
  end
  
  test "should save menu section if name is valid" do
    menu_section = MenuSection.new({:name => "Appetizers"})
    assert menu_section.save
  end
end
