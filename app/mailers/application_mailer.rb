class ApplicationMailer < ActionMailer::Base
  layout 'mailer'
  default from: ENV['SENDER_EMAIL']
end
