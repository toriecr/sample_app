# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  :user_name =>'apikey',
  :password  =>'SG.KznUvnpwTOa62kHaLgMeYw.LIWRWUfikdUxTWrBfoi0yTrb_s7H7ohj5jW-cKruX9',
  :domain    => 'heroku.com',
  :address   => 'smtp.sendgrid.net',
  :port      => 465,
  :authentication => :plain,
  :enable_starttls_auto => true
}