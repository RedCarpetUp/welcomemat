class ApplicantMailer < ActionMailer::Base
  layout 'mailer'
  def message_email(job, application, applicant_message)
    @job = job
    @application  = application
    @message = applicant_message
    @reply_mail = "applicant-"+@application.hashid+"@"+"wm-mail.hackergully.com"
    @job_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@job.organisation.id.to_s+"/jobs/"+@job.id.to_s
    @application_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@job.organisation.id.to_s+"/jobs/"+@job.id.to_s+"/applications/"+@application.hashid
    mail(from: @reply_mail, to: [@application.email]+@application.extra_applicant_emails.where(:is_greyed => false).pluck(:email), subject: 'New message regarding your job application')
  end

  def move_notify(application, job, new_job)
    @job = job
    @new_job = new_job
    @application  = application
    @reply_mail = "applicant-"+@application.hashid+"@"+"wm-mail.hackergully.com"
    @job_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@new_job.organisation.id.to_s+"/jobs/"+@new_job.id.to_s
    @application_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@new_job.organisation.id.to_s+"/jobs/"+@new_job.id.to_s+"/applications/"+@application.hashid
    mail(from: @reply_mail, to: [@application.email]+@application.extra_applicant_emails.where(:is_greyed => false).pluck(:email), subject: 'Your job application has been moved')
  end

  def status_notify(application, job)
    @job = job
    @application  = application
    @reply_mail = "applicant-"+@application.hashid+"@"+"wm-mail.hackergully.com"
    @job_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@job.organisation.id.to_s+"/jobs/"+@job.id.to_s
    @application_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@job.organisation.id.to_s+"/jobs/"+@job.id.to_s+"/applications/"+@application.hashid
    mail(from: @reply_mail, to: [@application.email]+@application.extra_applicant_emails.where(:is_greyed => false).pluck(:email), subject: 'Your application status has been changed')
  end

  def collab_message_email(job, application, collab, sender, applicant_message, from_applicant)
    @job = job
    @application  = application
    @collab = collab
    @sender = sender
    @message = applicant_message
    @sent_to = from_applicant === nil ? "collabs" : "applicant"
    @reply_mail = "collaborators-"+@application.hashid+"@"+"wm-mail.hackergully.com"
    @job_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@job.organisation.id.to_s+"/jobs/"+@job.id.to_s
    @application_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@job.organisation.id.to_s+"/jobs/"+@job.id.to_s+"/applications/"+@application.hashid
    @previous_messages = @application.applicant_messages.offset(1).limit(5)
    mail(from: @reply_mail, to: @collab.email, subject: '('+@application.hashid+')New message from collaborator '+@sender)
  end

  def recruiter_move_notify_new_collaborators(coll, job, application, old_job)
    @job = job
    @coll = coll
    @application = application
    @old_job = old_job
    @reply_mail = "applicant-"+@application.hashid+"@"+"wm-mail.hackergully.com"
    @job_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@job.organisation.id.to_s+"/jobs/"+@job.id.to_s
    @application_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@job.organisation.id.to_s+"/jobs/"+@job.id.to_s+"/applications/"+@application.hashid
    mail(from: @reply_mail, to: @coll.email, subject: '('+@application.hashid+')New application moved to your job '+@job.name)
  end

  def recruiter_move_notify_old_collaborators(coll, job, application, new_job, changer)
    @job = job
    @coll = coll
    @application = application
    @new_job = new_job
    @changer = changer
    @reply_mail = "collaborators-"+@application.hashid+"@"+"wm-mail.hackergully.com"
    @job_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@job.organisation.id.to_s+"/jobs/"+@job.id.to_s
    @application_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@job.organisation.id.to_s+"/jobs/"+@job.id.to_s+"/applications/"+@application.hashid
    mail(from: @reply_mail, to: @coll.email, subject: '('+@application.hashid+')Application moved out of your job '+@job.name)
  end

  def recruiter_status_change_notify_collaborators(coll, job, application, changer)
    @job = job
    @coll = coll
    @application = application
    @changer = changer
    @reply_mail = "applicant-"+@application.hashid+"@"+"wm-mail.hackergully.com"
    @job_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@job.organisation.id.to_s+"/jobs/"+@job.id.to_s
    @application_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@job.organisation.id.to_s+"/jobs/"+@job.id.to_s+"/applications/"+@application.hashid
    mail(from: @reply_mail, to: @coll.email, subject: '('+@application.hashid+')Status updated of an application to your job '+@job.name)
  end

  def recruiter_notify(coll, job, application)
  	@job = job
  	@coll = coll
  	@application = application
  	@reply_mail = "applicant-"+@application.hashid+"@"+"wm-mail.hackergully.com"
    @job_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@job.organisation.id.to_s+"/jobs/"+@job.id.to_s
    @application_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@job.organisation.id.to_s+"/jobs/"+@job.id.to_s+"/applications/"+@application.hashid
  	mail(from: @reply_mail, to: @coll.email, subject: '('+@application.hashid+')New application to your job '+@job.name)
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
    mail(from: @reply_mail, to: @coll.email, subject: '('+@application.hashid+')New message from applicant '+@application.name+' to your job '+@job.name)
  end

  def added_collab_message(new_coll, coll, job)
    @job = job
    @coll = coll
    @new_coll = new_coll
    @job_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@job.organisation.id.to_s+"/jobs/"+@job.id.to_s
    mail(from: "dontreply@wm-mail.hackergully.com", to: @coll.email, subject: @coll == @new_coll ? "You have been added as collaborator to job "+@job.name+" of "+@job.organisation.name : @new_coll.name+" has been added as collaborator to job "+@job.name+" of "+@job.organisation.name)
  end

  def removed_collab_message(old_coll, coll, job)
    @job = job
    @coll = coll
    @old_coll = old_coll
    @job_url = "https://welcomemat-hackergully-com.herokuapp.com/organisations/"+@job.organisation.id.to_s+"/jobs/"+@job.id.to_s
    mail(from: "dontreply@wm-mail.hackergully.com", to: @coll.email, subject: @coll == @old_coll ? "You have been removed as collaborator from job "+@job.name+" of "+@job.organisation.name : @old_coll.name+" has been removed as collaborator from job "+@job.name+" of "+@job.organisation.name)
  end

end