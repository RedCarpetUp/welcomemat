class JobsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :mail_multiple]
  before_action :set_organisation, only: [:edit, :update, :show, :index, :create, :new, :destroy, :mail_multiple]
  before_action :set_job, only: [:show, :edit, :update, :destroy, :mail_multiple]
  before_action :require_owner, only: [:new, :create]
  before_action :require_collaborator, only: [:edit, :update, :destroy, :mail_multiple]

  def show
  end

  def mail_multiple
    applications = Array.new
    applications_filtered_for_repeats = params[:applications].map {|x| x.split("_")[0]}.uniq.map {|x| params[:applications].include?(x.to_s+"_1") ? x.to_s+"_1" : x.to_s+"_0"}
    if applications_filtered_for_repeats.include?("all_1")
      arr_of_ids_to_except = (applications_filtered_for_repeats - ["all_1"]).map {|item| item.split("_")[1] == "0" ? item.split("_")[0].to_i : nil}.select { |item| !item.nil? }
      applications = @job.applications.where.not(id: arr_of_ids_to_except)
    elsif applications_filtered_for_repeats.include?("all_0")
      arr_of_ids = (applications_filtered_for_repeats - ["all_0"]).map {|item| item.split("_")[1] == "1" ? item.split("_")[0].to_i : nil}.select { |item| !item.nil? }
      arr_of_ids.each do |appl_id|
        begin
        an_appl = Application.find(appl_id)
        rescue
          applications = nil
          break
        else
          applications.push(an_appl)
        end
      end
    end

    if applications == nil
      flash[:error] = "Improper applications selection"
      redirect_to organisation_job_applications_path(@organisation, @job) and return
    end

    applications.each do |application|
      applicant_message = ApplicantMessage.new
      template = Template.new
      begin
        template = Liquid::Template.parse(params["content"])
        applicant_message.content = template.render!({'applicant' => application.name, 'job' => @job.name, 'organisation' => @organisation.name}, { strict_filters: true, strict_variables: true })
      rescue
        flash[:error] = "You have errors in your liquid syntax!"
        redirect_to organisation_job_applications_path(@organisation, @job) and return
        #render 'applications/index'
        #On the index page user had given in params the page_no,
        #i can't have it in this action since its never given to this request,
        #so I can't recreate user's existing state,
        #so for now est thing to do is to redirect and lose all data,
        #later if this is required we will have to do page param passed with this request,
        #which again wil need the index code of applications to be reimpemented here,
        #which seems a bad thing to do
      else
        applicant_message.user = current_user
        applicant_message.application = application
        applicant_message.from_applicant = false

        if applicant_message.save
          ApplicantMailer.message_email(@job, application, applicant_message.content).deliver_later
          #@job.collaborators.each do |coll|
          #  if current_user != coll
          #    ApplicantMailer.collab_message_email(@job, @application, coll, @applicant_message.user.name, @applicant_message.content, @applicant_message.from_applicant).deliver_later
          #  end
          #end
        else
          flash[:error] = "Message Sending failed!"
          redirect_to organisation_job_applications_path(@organisation, @job) and return
        end
      end
    end
    #if user has given incorrect data for content, it will fail at first iteration only and hence the operation will be atomic,
    #if user has given incorrect array of applications, we will check it and return immediately hence atomic
    flash[:success] = "Message Sent!"
    redirect_to organisation_job_applications_path(@organisation, @job)
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
    #@job.collaborators << current_user

    if @job.save
      @job.collaborators << current_user
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
    params.require(:job).permit(:name, :description, :fields_required)
    #params.require(:job).permit(:name, :description, :fields).except(:fields).merge(:fields => params["job"]["fields"].split(",").map { |s| s })
  end

end