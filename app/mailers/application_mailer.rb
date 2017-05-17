class ApplicationMailer < ActionMailer::Base
  default from: 'from@'+Rails.application.secrets.mailgun_domain
  layout 'mailer'
end
