require 'test_helper'

class MenuTest < ActiveSupport::TestCase
  test "should not save menu without name" do
    menu = Menu.new
    assert !menu.save
  end
  
  test "should not save menu if name is less than 1 character" do
    menu = Menu.new({:name => ""})
    assert !menu.save
  end
  
  test "should save menu if name is valid" do
    menu = Menu.new({:name => "menu"})
    assert menu.save
  end
end
