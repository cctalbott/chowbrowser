class OrderMailer < ActionMailer::Base
  default :from => "ChowBrowser Orders <orders@domain.com>",
    :reply_to => "ChowBrowser Orders <orders@domain.com>"

  def order_confirmation(order)
    @order = order

    mail(
      :to => @order.email,
      :subject => "Your ChowBrowser order"
    )
  end
end
