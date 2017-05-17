class ApplicantMailer < ActionMailer::Base
  layout 'mailer'
  def message_email(job, applicant, applicant_message)
    @job = job
    @applicant  = applicant
    @message = applicant_message
    @reply_mail = "careers"+@applicant.unique_key+"@"+Rails.application.secrets.mailgun_domain
    mail(from: @reply_mail, to: @applicant.email, subject: 'New message regarding your job application')
  end

end