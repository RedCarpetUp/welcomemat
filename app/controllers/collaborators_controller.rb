class CollaboratorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organisation
  before_action :set_job
  before_action :require_collaborators

  def index
    @collaborators = @job.collaborators
  end

  def destroy
    @user = User.find(params[:id])

    if @user.email == @organisation.owner.email
      flash[:error] = "Organisation owner can't be removed from collaborators"
      redirect_to organisation_job_collaborators_path(@organisation, @job) and return 
    end

    @job.collaborators.delete(@user)
    flash[:success] = 'Collaborator Removed'
    redirect_to organisation_job_collaborators_path(@organisation, @job)
  end

  def create
    @user = User.where(email: params[:email]).first

    if @user == nil
      flash[:error] = "No user with this email found"
      redirect_to organisation_job_collaborators_path(@organisation, @job) and return      
    end

    if @job.collaborators.include?(@user)
      flash[:error] = "This user is already a collaborator"
      redirect_to organisation_job_collaborators_path(@organisation, @job) and return
    end

    if @job.applications.include?(@user)
      flash[:error] = "This user is an applicant for this job, hence can\'t collaborate in selection process"
      redirect_to organisation_job_collaborators_path(@organisation, @job) and return
    end

    @job.collaborators << @user
    if @job.collaborators.include?(@user)
      flash[:success] = "Collaborator added successfully"
    else
      flash[:error] = "Collaborator adding failed"
    end
    redirect_to organisation_job_collaborators_path(@organisation, @job)
  end

  private

  def set_organisation
    @organisation = Organisation.find(params[:organisation_id])
  end

  def set_job
    @job = Job.find(params[:job_id])
  end

  def require_collaborators
    if !@organisation.jobs.collect{|x| x.collaborators}.flatten.uniq.include?(current_user)
      flash[:danger] = 'You can only create templates for organisations you collaborate for'
      redirect_to organisation_path(@organisation)
    end
  end

end
