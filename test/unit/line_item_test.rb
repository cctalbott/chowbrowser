require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
  test "should save line item" do
    line_item = LineItem.new
    assert line_item.save
  end
end
