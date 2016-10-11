require 'test_helper'

class LocationTest < ActiveSupport::TestCase
=begin  
  test "the truth" do
    assert true
  end
=end
=begin  
  test "should report error" do
    # some_undefined_variable is not defined elsewhere in the test case
    some_undefined_variable
    assert true
  end
=end

  test "should not save location without address, region and city" do
    location = Location.new
    assert !location.save
  end

  test "should not save location if address, region or city are less than 1 character" do
    location = Location.new({:address => "", :region => "", :city => ""})
    assert !location.save
  end
  
  test "should save location if address, region or city are more than 1 character" do
    location = Location.new({:address => "123 First St", :region => "TX", :city => "Lubbock"})
    assert location.save
  end
end
