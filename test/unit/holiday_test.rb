require 'test_helper'

class HolidayTest < ActiveSupport::TestCase
  test "should not save holiday without date" do
    holiday = Holiday.new
    assert !holiday.save
  end
  
  test "should not save holiday with date less than 1 character" do
    holiday = Holiday.new(:day => "")
    assert !holiday.save
  end
  
  test "should save holiday with valid date" do
    holiday = Holiday.new(:day => "2011-12-27")
    assert holiday.save
  end
end