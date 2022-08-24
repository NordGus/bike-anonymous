class ApplicationMailer < ActionMailer::Base
  default from: ENV["BIKES_ANONYMOUS_APPLICATION_EMAIL"]
  layout "mailer"
end
