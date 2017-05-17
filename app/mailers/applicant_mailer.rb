class ApplicantMailer < ActionMailer::Base
  layout 'mailer'
  def message_email(job, applicant, applicant_message)
    hashids = Hashids.new Rails.application.secrets.secret_key_base
    @job = job
    @applicant  = applicant
    @message = applicant_message
    @reply_mail = "careers"+hashids.encode(@applicant.id)+"@"+Rails.application.secrets.mailgun_domain
    mail(from: @reply_mail, to: @applicant.email, subject: 'New message regarding your job application')
  end

  def recruiter_notify(coll, job, application)
  	@job = job
  	@coll = coll
  	@application = application
  	@reply_mail = "careers@"+Rails.application.secrets.mailgun_domain
  	mail(from: @reply_mail, to: @coll.email, subject: 'New application to your job '+@job.name)
  end

end