require 'test_helper'

class RestaurantTest < ActiveSupport::TestCase
  test "should not save restaurant without name" do
    restaurant = Restaurant.new
    assert !restaurant.save
  end
  
  test "should not save restaurant if name is less than 1 character" do
    restaurant = Restaurant.new({:name => ""})
    assert !restaurant.save
  end
  
  test "should save restaurant if name is valid" do
    restaurant = Restaurant.new({:name => "Tokyo"})
    assert restaurant.save
  end
end
