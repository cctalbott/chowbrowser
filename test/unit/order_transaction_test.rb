require 'test_helper'

class OrderTransactionTest < ActiveSupport::TestCase
  test "should not save order transaction without amount" do
    order_transaction = OrderTransaction.new
    assert !order_transaction.save
  end

  test "should not save order transaction if amount is less than 1 character" do
    order_transaction = OrderTransaction.new({:amount => ""})
    assert !order_transaction.save
  end

  test "should not save order transaction if amount is more than 7 character" do
    order_transaction = OrderTransaction.new({:amount => 100000.23})
    assert !order_transaction.save
  end

  test "should save order transaction if amount is valid" do
    order_transaction = OrderTransaction.new({:amount => 100.23})
    assert order_transaction.save
  end
end
