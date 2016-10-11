ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "yourdomain.com",
  :user_name            => "orders@yourdomain.com",
  :password             => "PASSHERE",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
