class EmailinController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    logger.debug params
    if params[:key] == Rails.application.secrets.auth0_hook_key
      section = params[:recipient].split("@")[0].split("-")[0]
      unique_key = params[:recipient].split("@")[0].split("-")[1]
      sender = params[:sender]
      content = params[:"stripped-text"]
      if section == "careers"
        application = Application.find(unique_key)
        if application.email == sender
          applicant_message = ApplicantMessage.new
          applicant_message.content = content
          applicant_message.application = application
          applicant_message.from_applicant = true
          applicant_message.save
        elsif application.job.collaborators.include?(User.where(email: sender).first)
          #email from collaborator regarding unique key application, send to all collaborators
        end
      end
    end
  end

end