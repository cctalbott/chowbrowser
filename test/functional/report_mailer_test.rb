require 'test_helper'
#include ActionView::Helpers::NumberHelper
#include Admin::BatchesHelper

class ReportMailerTest < ActionMailer::TestCase
=begin
  test "the truth" do
    assert true
  end
=end
  def test_report_email
    orders = [orders(:one)]

    # Send the email, then test that it got queued
    email = ReportMailer.orders_report(orders).deliver
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal [orders.first.restaurant.report_email], email.to
    assert_equal "ChowBrowser orders report", email.subject
    assert_equal ["info@domain.com"], email.from
    assert_equal ["info@domain.com"], email.reply_to

    assert_match(/Orders on #{orders.first.purchased_at.strftime("%Y %b %d %a %l:%M%p %Z")}/, email.encoded)

    assert_match(/<h1>Orders on #{orders.first.purchased_at.strftime("%Y %b %d %a %l:%M%p %Z")}<\/h1>/, email.encoded)
    assert_match(/<table>/, email.encoded)
    assert_match(/<tr>/, email.encoded)
    assert_match(/<th>ID<\/th>/, email.encoded)
    assert_match(/<th>Customer<\/th>/, email.encoded)
    assert_match(/<th>SubTotal<\/th>/, email.encoded)
    assert_match(/<\/tr>/, email.encoded)
    orders.each do |order|
      assert_match(/ID: #{order.id} | Customer: #{order.email} | Sub-Total: #{number_to_currency(order.price)}/, email.encoded)

      assert_match(/<tr>/, email.encoded)
      assert_match(/<td>#{order.id}<\/td>/, email.encoded)
      assert_match(/<td>#{order.email}<\/td>/, email.encoded)
      assert_match("<td>#{number_to_currency(order.price)}</td>", email.encoded)
      assert_match(/<\/tr>/, email.encoded)
    end
    assert_match(/<\/table>/, email.encoded)

    assert_match(/Combined Totals/, email.encoded)
    assert_match("SubTotal: #{number_to_currency(combined_subtotal(orders))}", email.encoded)
    assert_match("Total: #{number_to_currency(combined_total(orders))}", email.encoded)
    assert_match("Restaurant Deposit: #{number_to_currency(combined_restaurant_deposit(orders))}", email.encoded)

    assert_match(/<h2>Combined Totals<\/h2>/, email.encoded)
    assert_match(/<table>/, email.encoded)
    assert_match(/<tr>/, email.encoded)
    assert_match(/<th>SubTotal<\/th>/, email.encoded)
    assert_match(/<th>Total<\/th>/, email.encoded)
    assert_match(/<th>Restaurant Deposit<\/th>/, email.encoded)
    assert_match(/<\/tr>/, email.encoded)
    assert_match(/<tr>/, email.encoded)
    assert_match("<td>#{number_to_currency(combined_subtotal(orders))}</td>", email.encoded)
    assert_match("<td>#{number_to_currency(combined_total(orders))}</td>", email.encoded)
    assert_match("<td>#{number_to_currency(combined_restaurant_deposit(orders))}</td>", email.encoded)
    assert_match(/<\/tr>/, email.encoded)
    assert_match(/<\/table>/, email.encoded)
  end
end
