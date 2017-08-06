class ApplicationsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :index, :change_status, :move_application]
  before_action :set_organisation
  before_action :set_job
  before_action :set_application, only: [:show]
  before_action :require_collaborators, only: [:show, :index, :change_status, :move_application]

  ITEMS_PER_PAGE = 5

  def move_application
    @application = Application.find(params[:application_id])
    if @application.status != "Moved Out"
      @new_job = @organisation.jobs.find(params[:new_job_id])
      @application.status = "Moved Out"
      @new_application = Application.new
      @new_application.name = @application.name
      @new_application.email = @application.email
      @new_application.description = @application.description
      @new_application.extra_fields = @application.extra_fields
      @new_application.job = @new_job
      @new_application.status = "Moved In"
      if @application.save && @new_application.save
        ApplicantMailer.move_notify(@new_application, @job, @new_job).deliver_later
        @job.collaborators.each do |coll|
          ApplicantMailer.recruiter_move_notify_old_collaborators(coll, @job, @application, @new_job, current_user).deliver_later
        end
        @new_job.collaborators.each do |coll|
          ApplicantMailer.recruiter_move_notify_new_collaborators(coll, @new_job, @new_application, @job).deliver_later
        end
        flash[:success] = "Application moved successfully!"
        redirect_to organisation_job_application_path(@organisation, @job, @application)
      else
        flash[:error] = "Application move failed!"
        redirect_to organisation_job_application_path(@organisation, @job, @application)
      end
    else
      flash[:error] = "Application move failed!"
      redirect_to organisation_job_application_path(@organisation, @job, @application)
    end
  end

  def change_status
    @application = Application.find(params[:application_id])
    if @application.status != "Moved Out"
      if params[:status] != @application.status && ["Shortlisted", "Applied", "Rejected", "Hired"].include?(params[:status])
        @application.status = params[:status]
        if @application.save
          flash[:success] = "Status change successful!"
          ApplicantMailer.status_notify(@application, @job).deliver_later
          @job.collaborators.each do |coll|
            ApplicantMailer.recruiter_status_change_notify_collaborators(coll, @job, @application, current_user).deliver_later
          end
          redirect_to organisation_job_application_path(@organisation, @job, @application)
        else
          flash[:error] = "Status change failed!"
          redirect_to organisation_job_application_path(@organisation, @job, @application)
        end
      else
        flash[:error] = "Status change failed!"
        redirect_to organisation_job_application_path(@organisation, @job, @application)
      end
    else
      flash[:error] = "Status change failed!"
      redirect_to organisation_job_application_path(@organisation, @job, @application)
    end
  end

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
    if params[:query]
      @applications = @applications
    end
    if params[:filter] && params[:filter] == "status"
      if params[:status]
        @applications = @applications.where(status: params[:status])
      end
    end
    if @applications.empty?
      @show_more = false
    else
      @show_more = !(@page == (@applications.count.to_f/ITEMS_PER_PAGE).ceil)
    end
    @applications = @applications.offset((@page - 1) * ITEMS_PER_PAGE).limit(ITEMS_PER_PAGE)
    @cur_url = organisation_job_applications_path
  end

  def new
    @application = Application.new
  end

  def create
    @application = Application.new(application_params)
    @application.job = @job
    @application.status = "Applied"

    if params[:application].slice(*@job.fields["entries"].map {|x| x["name"]}).keys.length > 0
      @application.extra_fields = params[:application].slice(*@job.fields["entries"].map {|x| x["name"]}).permit!.to_hash
    end

    if verify_recaptcha(model: @application) && @application.save
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
    @organisation = Organisation.find(hashid_from_param(params[:organisation_id]))
  end

  def set_application
    @application = Application.find(params[:id])
  end

  def set_job
    @job = Job.find(hashid_from_param(params[:job_id]))
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
