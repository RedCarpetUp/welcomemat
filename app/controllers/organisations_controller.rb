class OrganisationsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_organisation, only: [:edit, :update, :destroy]
  before_action :require_owner, only: [:edit, :update, :destroy]

  def index
    @organisations = Organisation.all
  end

  def new
    @organisation = Organisation.new
  end

  def create
    @organisation = Organisation.new(organisation_params)
    @organisation.owner = current_user

    if @organisation.save
      flash[:success] = "Organisation Created!"
      redirect_to organisation_jobs_path(@organisation)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @organisation.update(organisation_params)
      flash[:success] = 'Updated Successfully!'
      redirect_to organisation_jobs_path(@organisation)
    else
      render :edit
    end
  end

  def destroy
    Organisation.find(hashid_from_param(params[:id])).destroy
    flash[:success] = 'Organisation Deleted'
    redirect_to root_path
  end

  private

  def set_organisation
    @organisation = Organisation.find(hashid_from_param(params[:id]))
  end

  def require_owner
    if current_user != @organisation.owner
      flash[:danger] = 'You can only edit your own organisations'
      redirect_to organisations_path
    end
  end

  def organisation_params
    params.require(:organisation).permit(:name, :description)
  end

end