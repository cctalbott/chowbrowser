require 'test_helper'

class CartTest < ActiveSupport::TestCase
  test "should save cart" do
    cart = Cart.new
    assert cart.save
  end
end
