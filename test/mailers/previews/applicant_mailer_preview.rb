class NotificationMailerPreview < ActionMailer::Preview

  def message_email
    ApplicantMailer.message_email(Job.first, Application.first, ApplicantMessage.first.content)
  end

  def collab_message_email
    ApplicantMailer.collab_message_email(Job.first, Application.first, User.first, ApplicantMessage.first.user.name, ApplicantMessage.first.content, ApplicantMessage.first.from_applicant)
  end
  def recruiter_notify
    ApplicantMailer.recruiter_notify(User.first, Job.first, Application.first)
  end
  def recruiter_message_notify
    ApplicantMailer.recruiter_message_notify(User.first, Job.first, Application.first, ApplicantMessage.first)
  end
end