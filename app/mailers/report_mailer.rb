include ActionView::Helpers::NumberHelper
include Admin::BatchesHelper

class ReportMailer < ActionMailer::Base
  default :from => "ChowBrowser Reports <info@domain.com>",
    :reply_to => "ChowBrowser Reports <info@domain.com>"

  def orders_report(orders, email)
    @orders = orders

    #attachments['orders_report.pdf'] = File.read("/admin/orders/#{@orders.first.cart.purchased_at.year}/#{@orders.first.cart.purchased_at.month}/#{@orders.first.cart.purchased_at.day}/restaurant/#{@orders.first.restaurant.id}.pdf")
    #attachments['orders_report.csv'] = File.read("/admin/orders/#{@orders.first.cart.purchased_at.year}/#{@orders.first.cart.purchased_at.month}/#{@orders.first.cart.purchased_at.day}/restaurant/#{@orders.first.restaurant.id}.csv")
    # change :to to purchaser.email in production
    mail(
      :to => email,
      :subject => "ChowBrowser orders report"
    )
  end
end
