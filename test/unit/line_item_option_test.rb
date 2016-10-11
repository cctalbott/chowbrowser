require 'test_helper'

class LineItemOptionTest < ActiveSupport::TestCase
  test "should save line item option" do
    line_item_option = LineItemOption.new
    assert line_item_option.save
  end
end
