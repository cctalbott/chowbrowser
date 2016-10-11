class PrintMailer < ActionMailer::Base
  default :from => "ChowBrowser Orders <orders@domain.com>",
    :reply_to => "ChowBrowser Orders <orders@domain.com>"

  def order_confirmation(order)
    @order = order
    
    @dd_emails = DeliveryDriver.dd_emails
    
    # change :to to purchaser.email in production
=begin
    mail(
      :to => @order.cart.location.printer.email,
      :bcc => "orders@domain.com",
      :bcc => @order.cart.location.email,
      :subject => "An order from ChowBrowser"
    )
=end
    mail(
      :to => @order.cart.location.email,
      :bcc => @dd_emails,
      :subject => "An order from ChowBrowser"
    )
  end
end
