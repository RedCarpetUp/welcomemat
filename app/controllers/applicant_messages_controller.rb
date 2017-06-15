class ApplicantMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organisation
  before_action :set_job
  before_action :set_application
  before_action :require_collaborators

  def create_to_applicant
    @applicant_message = ApplicantMessage.new
    begin
      @template = Liquid::Template.parse(params["applicant_message"]["content"])
      @applicant_message.content = @template.render!({'applicant' => @application.name, 'job' => @job.name, 'organisation' => @organisation.name}, { strict_filters: true, strict_variables: true })
    rescue
      flash[:error] = "You have errors in your liquid syntax!"
      @applicant_messages = @application.applicant_messages
      render 'applications/show'
    else
      @applicant_message.user = current_user
      @applicant_message.application = @application
      @applicant_message.from_applicant = false

      if @applicant_message.save
        ApplicantMailer.message_email(@job, @application, @applicant_message.content).deliver_later
        @job.collaborators.each do |coll|
          if current_user != coll
            ApplicantMailer.collab_message_email(@job, @application, coll, @applicant_message.user.name, @applicant_message.content, @applicant_message.from_applicant).deliver_later
          end
        end
        flash[:success] = "Message Sent!"
      else
        flash[:error] = "Message Sending failed!"
      end
      redirect_to organisation_job_application_path(@organisation, @job, @application)
    end
  end

  def create_to_collaborators
    @applicant_message = ApplicantMessage.new
    begin
      @template = Liquid::Template.parse(params["applicant_message"]["content"])
      @applicant_message.content = @template.render!({'applicant' => @application.name, 'job' => @job.name, 'organisation' => @organisation.name}, { strict_filters: true, strict_variables: true })
    rescue
      flash[:error] = "You have errors in your liquid syntax!"
      @applicant_messages = @application.applicant_messages
      render 'applications/show'
    else
      @applicant_message.user = current_user
      @applicant_message.application = @application
      @applicant_message.from_applicant = nil

      if @applicant_message.save
        #ApplicantMailer.message_email(@job, @application, @applicant_message.content).deliver_later
        @job.collaborators.each do |coll|
          if current_user != coll
            ApplicantMailer.collab_message_email(@job, @application, coll, @applicant_message.user.name, @applicant_message.content, @applicant_message.from_applicant).deliver_later
          end
        end
        flash[:success] = "Message Sent!"
      else
        flash[:error] = "Message Sending failed!"
      end
      redirect_to organisation_job_application_path(@organisation, @job, @application)
    end
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

end
