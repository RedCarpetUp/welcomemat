class ApplicationsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :index]
  before_action :set_organisation
  before_action :set_job
  before_action :set_application, only: [:show]
  before_action :require_collaborators, only: [:show, :index]

  ITEMS_PER_PAGE = 2

  def show
    @applicant_messages = @application.applicant_messages
    @applicant_message = ApplicantMessage.new
    @template = Template.new
    @extra_applicant_email = ExtraApplicantEmail.new
  end

  def index
    if params[:page]
      @page = params[:page].to_i
    else
      @page = 1
    end
    @applications = @job.applications
    @show_more = !(@page == (@applications.count.to_f/ITEMS_PER_PAGE).ceil)
    @applications = @applications.offset((@page - 1) * ITEMS_PER_PAGE).limit(ITEMS_PER_PAGE)
    @cur_url = organisation_job_applications_path
  end

  def new
    @application = Application.new
  end

  def create
    @application = Application.new(application_params)
    @application.job = @job

    if params[:application].slice(*@job.fields).keys.length > 0
      @application.extra_fields = params[:application].slice(*@job.fields).permit!.to_hash
    end

    if @application.save
      @job.collaborators.each do |coll|
        ApplicantMailer.recruiter_notify(coll, @job, @application).deliver_later
      end
      flash[:success] = "Application Created!"
      redirect_to organisation_job_path(@organisation, @job)
    else
      render :new
    end
  end

  private

  def set_organisation
    @organisation = Organisation.find(params[:organisation_id])
  end

  def set_application
    @application = Application.find(params[:id])
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

  def application_params
    params.require(:application).permit(:name, :email, :description)
  end

end
