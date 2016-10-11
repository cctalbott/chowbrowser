require 'test_helper'

class MenuHourTest < ActiveSupport::TestCase
  test "should not save menu hour without menu start hour" do
    menu_hour = MenuHour.new(:menu_end_hour => 0, :menu_start_min => 00, :menu_end_min => 01)
    assert !menu_hour.save
  end

  test "should not save menu hour without menu end hour" do
    menu_hour = MenuHour.new(:menu_start_hour => 0, :menu_start_min => 00, :menu_end_min => 01)
    assert !menu_hour.save
  end

  test "should not save menu hour without menu start min" do
    menu_hour = MenuHour.new(:menu_start_hour => 0, :menu_end_hour => 0, :menu_end_min => 01)
    assert !menu_hour.save
  end

  test "should not save menu hour without menu end min" do
    menu_hour = MenuHour.new(:menu_start_hour => 0, :menu_end_hour => 0, :menu_start_min => 00)
    assert !menu_hour.save
  end

  test "should not save menu hour with start hr less than 1 character" do
    menu_hour = MenuHour.new(:menu_start_hour => "", :menu_end_hour => 0, :menu_start_min => 00, :menu_end_min => 01)
    assert !menu_hour.save
  end

  test "should not save menu hour with end hr less than 1 character" do
    menu_hour = MenuHour.new(:menu_start_hour => 0, :menu_end_hour => "", :menu_start_min => 00, :menu_end_min => 01)
    assert !menu_hour.save
  end

  test "should not save menu hour with start min less than 1 character" do
    menu_hour = MenuHour.new(:menu_start_hour => 0, :menu_end_hour => 0, :menu_start_min => "", :menu_end_min => 01)
    assert !menu_hour.save
  end

  test "should not save menu hour with end min less than 1 character" do
    menu_hour = MenuHour.new(:menu_start_hour => 0, :menu_end_hour => 0, :menu_start_min => 00, :menu_end_min => "")
    assert !menu_hour.save
  end

  test "should not save menu hour with start hr more than 2 character" do
    menu_hour = MenuHour.new(:menu_start_hour => 123, :menu_end_hour => 0, :menu_start_min => 00, :menu_end_min => 01)
    assert !menu_hour.save
  end

  test "should not save menu hour with end hr more than 2 character" do
    menu_hour = MenuHour.new(:menu_start_hour => 12, :menu_end_hour => 123, :menu_start_min => 00, :menu_end_min => 01)
    assert !menu_hour.save
  end

  test "should not save menu hour with start min more than 2 character" do
    menu_hour = MenuHour.new(:menu_start_hour => 12, :menu_end_hour => 0, :menu_start_min => 123, :menu_end_min => 01)
    assert !menu_hour.save
  end

  test "should not save menu hour with end min more than 2 character" do
    menu_hour = MenuHour.new(:menu_start_hour => 12, :menu_end_hour => 0, :menu_start_min => 00, :menu_end_min => 123)
    assert !menu_hour.save
  end

  test "should not save menu hour if start hr not integer" do
    menu_hour = MenuHour.new(:menu_start_hour => "ab", :menu_end_hour => 0, :menu_start_min => 00, :menu_end_min => 01)
    assert !menu_hour.save
  end

  test "should not save menu hour if end hr not integer" do
    menu_hour = MenuHour.new(:menu_start_hour => 0, :menu_end_hour => "ab", :menu_start_min => 00, :menu_end_min => 01)
    assert !menu_hour.save
  end

  test "should not save menu hour if start min not integer" do
    menu_hour = MenuHour.new(:menu_start_hour => 0, :menu_end_hour => 0, :menu_start_min => "ab", :menu_end_min => 01)
    assert !menu_hour.save
  end

  test "should not save menu hour if end min not integer" do
    menu_hour = MenuHour.new(:menu_start_hour => 0, :menu_end_hour => 0, :menu_start_min => 00, :menu_end_min => "ab")
    assert !menu_hour.save
  end

  test "should save menu hour if start hr end hr start min and end min are valid" do
    menu_hour = MenuHour.new(:menu_start_hour => 11, :menu_end_hour => 0, :menu_start_min => 00, :menu_end_min => 01)
    assert menu_hour.save
  end
end
