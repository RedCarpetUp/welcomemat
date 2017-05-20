class ApplicantMailer < ActionMailer::Base
  layout 'mailer'
  def message_email(job, applicant, applicant_message)
    @job = job
    @applicant  = applicant
    @message = applicant_message
    @reply_mail = "careers-"+@applicant.hashid+"@"+"wm-mail.hackergully.com"
    mail(from: @reply_mail, to: @applicant.email, subject: 'New message regarding your job application')
  end

  def recruiter_notify(coll, job, application)
  	@job = job
  	@coll = coll
  	@application = application
  	@reply_mail = "careers-"+@application.hashid+"@"+"wm-mail.hackergully.com"
  	mail(from: @reply_mail, to: @coll.email, subject: 'New application to your job '+@job.name)
  end

end