class EmailinController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    logger.debug params
    if params[:key] == Rails.application.secrets.auth0_hook_key
      section = params[:recipient].split("@")[0].split("-")[0]
      unique_key = params[:recipient].split("@")[0].split("-")[1]
      sender = params[:sender]
      content = params[:"stripped-text"]
      if section == "collaborators"
        application = Application.find(unique_key)
        sender_user = User.where(email: sender).first
        if application.job.collaborators.include?(sender_user)
          applicant_message = ApplicantMessage.new
          applicant_message.content = content
          applicant_message.application = application
          applicant_message.user = sender_user
          applicant_message.from_applicant = nil
          if applicant_message.save
            application.job.collaborators.each do |coll|
              if sender_user != coll
                ApplicantMailer.collab_message_email(application.job, application, coll, applicant_message.user.name, applicant_message.content, applicant_message.from_applicant).deliver_later
              end
            end
          end
        end
      elsif section == "applicant"
        application = Application.find(unique_key)
        sender_user = User.where(email: sender).first
        if application.job.collaborators.include?(sender_user)
          applicant_message = ApplicantMessage.new
          applicant_message.content = content
          applicant_message.application = application
          applicant_message.user = sender_user
          applicant_message.from_applicant = false
          if applicant_message.save
            ApplicantMailer.message_email(application.job, application, applicant_message.content).deliver_later
            application.job.collaborators.each do |coll|
              if sender_user != coll
                ApplicantMailer.collab_message_email(application.job, application, coll, applicant_message.user.name, applicant_message.content, applicant_message.from_applicant).deliver_later
              end
            end
          end
        end
        elsif application.email == sender
          applicant_message = ApplicantMessage.new
          applicant_message.content = content
          applicant_message.application = application
          applicant_message.from_applicant = true
          if applicant_message.save
            application.job.collaborators.each do |coll|
              ApplicantMailer.recruiter_message_notify(coll, application.job, application, applicant_message).deliver_later
            end
          end
        end
      end
    end
  end

end