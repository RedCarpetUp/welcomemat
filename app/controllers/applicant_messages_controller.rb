class ApplicantMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organisation
  before_action :set_job
  before_action :set_application
  before_action :require_collaborators

  def create_to_applicant
    @applicant_message = ApplicantMessage.new(applicant_message_params)
    @applicant_message.user = current_user
    @applicant_message.application = @application
    @applicant_message.from_applicant = false

    if @applicant_message.save
      ApplicantMailer.message_email(@job, @application, @applicant_message.content).deliver_later
      @job.collaborators.each do |coll|
        if current_user != coll
          ApplicantMailer.collab_message_email(@job, @application, coll, @applicant_message.user.name, @applicant_message.content, @application_message.from_applicant).deliver_later
        end
      end
      flash[:success] = "Message Sent!"
    else
      flash[:success] = "Message Sending failed!"
    end
    redirect_to organisation_job_application_path(@organisation, @job, @application)
  end

  def create_to_collaborators
    @applicant_message = ApplicantMessage.new(applicant_message_params)
    @applicant_message.user = current_user
    @applicant_message.application = @application
    @applicant_message.from_applicant = nil

    if @applicant_message.save
      #ApplicantMailer.message_email(@job, @application, @applicant_message.content).deliver_later
      @job.collaborators.each do |coll|
        if current_user != coll
          ApplicantMailer.collab_message_email(@job, @application, coll, @applicant_message.user.name, @applicant_message.content, @application_message.from_applicant).deliver_later
        end
      end
      flash[:success] = "Message Sent!"
    else
      flash[:success] = "Message Sending failed!"
    end
    redirect_to organisation_job_application_path(@organisation, @job, @application)
  end

  private

  def set_organisation
    @organisation = Organisation.find(params[:organisation_id])
  end

  def set_application
    @application = Application.find(params[:application_id])
  end

  def set_job
    @job = Job.find(params[:job_id])
  end

  def require_collaborators
    if !@job.collaborators.include?(current_user)
      flash[:danger] = 'You can only edit jobs you collaborate on'
      redirect_to organisation_job_path(@organisation, @job)
    end
  end

  def applicant_message_params
    params.require(:applicant_message).permit(:content)
  end

end
