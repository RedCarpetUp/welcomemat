class ApplicationsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :index]
  before_action :set_job, only: [:index, :create, :new]
  before_action :set_application, only: [:show]
  before_action :require_collaborators, only: [:show, :index]

  def show
  end

  def index
    @applications = @job.all
  end

  def new
    @application = Application.new
  end

  def create
    @application = Application.new(application_params)
    @application.job = @job

    if @application.save
      flash[:success] = "Application Created!"
      redirect_to job_path(@job)
    else
      render :new
    end
  end

  private

  def set_application
    @application = Application.find(params[:id])
  end

  def set_job
    @job = Job.find(params[:job_id])
  end

  def require_collaborators
    if @job.collaborators.include?(current_user)
      flash[:danger] = 'You can only edit jobs you collaborate on'
      redirect_to organisation_jobs_path(@organisation)
    end
  end

  def application_params
    params.require(:application).permit(:name, :description)
  end

end
