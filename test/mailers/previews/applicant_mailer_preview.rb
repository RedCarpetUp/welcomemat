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

  def move_notify
    ApplicantMailer.move_notify(Application.first, Job.first, Job.second)
  end

  def status_notify
    ApplicantMailer.status_notify(Application.first, Job.first)
  end

  def recruiter_move_notify_new_collaborators
    ApplicantMailer.recruiter_move_notify_new_collaborators(User.first, Job.first, Application.first, Job.second)
  end

  def recruiter_move_notify_old_collaborators
    ApplicantMailer.recruiter_move_notify_old_collaborators(User.first, Job.first, Application.first, Job.second, User.second)
  end

  def recruiter_status_change_notify_collaborators
    ApplicantMailer.recruiter_status_change_notify_collaborators(User.first, Job.first, Application.first, User.second)
  end

end