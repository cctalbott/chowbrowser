require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test "should not save order without ip_address, first_name, last_name, card_type, card_expires_on and email" do
    order = Order.new
    assert !order.save
  end

  test "should save order if ip_address, first_name, last_name, card_type, card_expires_on and email is valid" do
    order = Order.new({:ip_address => "192.168.0.1", :first_name => "Harry", :last_name => "Caray", :card_type => "Visa", :card_expires_on => "2012-12-27", :email => "youremail@domain.com"})
    assert order.save
  end
end
