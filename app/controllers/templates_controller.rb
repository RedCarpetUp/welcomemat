class TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organisation
  before_action :set_job
  before_action :set_application
  before_action :require_collaborators

  def create
    @template = Template.new
    @template.organisation = @organisation
    @template.content = params["template"]["content"]
    @template.name = params["template"]["name"]
    begin
      Liquid::Template.parse(params["template"]["content"]).render!({'applicant' => 'John Doe', 'job' => 'Generic Person', 'organisation' => 'Contoso'}, { strict_filters: true, strict_variables: true })
    rescue
      flash[:error] = "You have errors in your liquid syntax!"
      @applicant_messages = @application.applicant_messages
      @applicant_message = ApplicantMessage.new
      render 'applications/show'
    else
      if @template.save
        flash[:success] = "Template Saved"
        redirect_to organisation_job_application_path(@organisation, @job, @application)
      else
        flash[:success] = "Template saving failed!"
        @applicant_messages = @application.applicant_messages
        @applicant_message = ApplicantMessage.new
        render 'applications/show'
      end
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
    if !@organisation.jobs.collect{|x| x.collaborators}.flatten.uniq.include?(current_user)
      flash[:danger] = 'You can only create templates for organisations you collaborate for'
      redirect_to organisation_path(@organisation)
    end
  end

end
