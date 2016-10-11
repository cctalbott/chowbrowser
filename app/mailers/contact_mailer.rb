class ContactMailer < ActionMailer::Base
  default :from => "ChowBrowser <info@domain.com>",
    :reply_to => "ChowBrowser <info@domain.com>"

  def contact_confirmation(contact)
    @contact = contact

    mail(
      :to => @contact.email,
      :bcc => ["info@domain.com", "redacted@domain.com", "redacted@domain.com"],
      :subject => "Your ChowBrowser Inquiry"
    )
  end
end
