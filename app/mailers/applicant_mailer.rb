class ApplicantMailer < ActionMailer::Base
  layout 'mailer'
  def message_email(job, applicant, applicant_message)
    @job = job
    @applicant  = applicant
    @message = applicant_message
    @reply_mail = "applicant-"+@applicant.hashid+"@"+"wm-mail.hackergully.com"
    @job_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@job.organisation.id.to_s+"/jobs/"+@job.id.to_s
    @application_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@job.organisation.id.to_s+"/jobs/"+@job.id.to_s+"/applications/"+@applicant.hashid
    mail(from: @reply_mail, to: [@applicant.email]+@applicant.extra_applicant_emails.where(:is_greyed => false).pluck(:email), subject: 'New message regarding your job application')
  end

  def collab_message_email(job, applicant, collab, sender, applicant_message, from_applicant)
    @job = job
    @applicant  = applicant
    @collab = collab
    @sender = sender
    @message = applicant_message
    @sent_to = from_applicant === nil ? "collabs" : "applicant"
    @reply_mail = "collaborators-"+@applicant.hashid+"@"+"wm-mail.hackergully.com"
    @job_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@job.organisation.id.to_s+"/jobs/"+@job.id.to_s
    @application_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@job.organisation.id.to_s+"/jobs/"+@job.id.to_s+"/applications/"+@applicant.hashid
    @previous_messages = @applicant.applicant_messages.offset(1).limit(5)
    mail(from: @reply_mail, to: @collab.email, subject: 'New message regarding your job application')
  end

  def recruiter_notify(coll, job, application)
  	@job = job
  	@coll = coll
  	@application = application
  	@reply_mail = "applicant-"+@application.hashid+"@"+"wm-mail.hackergully.com"
    @job_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@job.organisation.id.to_s+"/jobs/"+@job.id.to_s
    @application_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@job.organisation.id.to_s+"/jobs/"+@job.id.to_s+"/applications/"+@application.hashid
  	mail(from: @reply_mail, to: @coll.email, subject: 'New application to your job '+@job.name)
  end

  def recruiter_message_notify(coll, job, application, message)
    @job = job
    @coll = coll
    @application = application
    @message = message
    @reply_mail = "applicant-"+@application.hashid+"@"+"wm-mail.hackergully.com"
    @job_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@job.organisation.id.to_s+"/jobs/"+@job.id.to_s
    @application_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@job.organisation.id.to_s+"/jobs/"+@job.id.to_s+"/applications/"+@application.hashid
    @previous_messages = @application.applicant_messages.offset(1).limit(5)
    mail(from: @reply_mail, to: @coll.email, subject: 'New message from applicant to your job '+@job.name)
  end

end