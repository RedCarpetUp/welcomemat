class JobsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_organisation, only: [:edit, :update, :show, :index, :create, :new, :destroy]
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  before_action :require_owner, only: [:new, :create]
  before_action :require_collaborator, only: [:edit, :update, :destroy]

  def show
  end

  def index
    @jobs = @organisation.jobs
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
    @job.organisation = @organisation
    @job.unique_key = "xxxxxxxxxxxx"
    @job.collaborators << current_user

    if @job.save
      flash[:success] = "Job Created!"
      redirect_to organisation_job_path(@organisation, @job)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @job.update(job_params)
      flash[:success] = 'Updated Successfully!'
      redirect_to organisation_job_path(@organisation, @job)
    else
      render :edit
    end
  end

  def destroy
    Job.find(params[:id]).destroy
    flash[:success] = 'Job Deleted'
    redirect_to organisation_jobs_path(@organisation)
  end

  private

  def set_job
    @job = Job.find(params[:id])
  end

  def set_organisation
    @organisation = Organisation.find(params[:organisation_id])
  end

  def require_collaborator
    if !@job.collaborators.include?(current_user)
      flash[:danger] = 'You can only edit jobs you collaborate on'
      redirect_to organisation_jobs_path(@organisation)
    end
  end

  def require_owner
    if current_user != @organisation.owner
      flash[:danger] = 'You can only edit your own organisations'
      redirect_to organisations_path
    end
  end

  def job_params
    params.require(:job).permit(:name, :description)
  end

end