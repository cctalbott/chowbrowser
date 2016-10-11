class DispatchMailer < ActionMailer::Base
  default :from => "ChowBrowser Orders <orders@domain.com>",
    :reply_to => "ChowBrowser Orders <orders@domain.com>"

  def dispatch_message(order)
    @order = order

    mail(
      :to => "redacted@domain.com",
      :bcc => ["redacted@domain.com", "redacted@domain.com", "redacted@domain.com"],
      :subject => "Unconfirmed ChowBrowser Order"
    )
  end
end
