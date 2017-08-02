class ExtraApplicantEmailsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organisation
  before_action :set_job
  before_action :set_application
  before_action :require_collaborators
  before_action :set_extra_applicant_email, only: [:grey, :ungrey]
  def create
    @extra_applicant_email = ExtraApplicantEmail.new
    @extra_applicant_email.application = @application
    @extra_applicant_email.email = params["extra_applicant_email"]["email"]
    if @extra_applicant_email.save
      flash[:success] = "Email Saved"
      redirect_to organisation_job_application_path(@organisation, @job, @application)
    else
      flash[:error] = "Email saving failed!"
      @applicant_messages = @application.applicant_messages
      @applicant_message = ApplicantMessage.new
      @template = Template.new
      render 'applications/show'
    end
  end

  def grey
    @extra_applicant_email.is_greyed = true
    if @extra_applicant_email.save
      flash[:success] = "Email Deleted"
    else
      flash[:error] = "Email deletion failed!"
    end
    redirect_to organisation_job_application_path(@organisation, @job, @application)
  end

  def ungrey
    @extra_applicant_email.is_greyed = false
    if @extra_applicant_email.save
      flash[:success] = "Email Restored"
    else
      flash[:error] = "Email restoration failed!"
    end
    redirect_to organisation_job_application_path(@organisation, @job, @application)
  end

  private

  def set_organisation
    @organisation = Organisation.find(hashid_from_param(params[:organisation_id]))
  end

  def set_application
    @application = Application.find(params[:application_id])
  end

  def set_job
    @job = Job.find(hashid_from_param(params[:job_id]))
  end

  def set_extra_applicant_email
    @extra_applicant_email = ExtraApplicantEmail.find(params[:id])
  end

  def require_collaborators
    if !@organisation.jobs.collect{|x| x.collaborators}.flatten.uniq.include?(current_user)
      flash[:danger] = 'You can only create edit email lists for organisations you collaborate for'
      redirect_to organisation_path(@organisation)
    end
  end

end
