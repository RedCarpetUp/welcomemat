module Api
  module V1
    class ApplicationsController < ApplicationController
      before_action :set_organisation
      before_action :set_job
      before_action :set_application, only: [:show]

      ITEMS_PER_PAGE = 10

      def show
        render json: @application.as_json(:except => [:deleted_at])
      end

      def index
        if params[:page]
          @page_no = params[:page].to_i
        else
          @page_no = 1
        end

        #if params[:query].present?
        #  @apps = App.search_by_pg(params[:query])
        #else
        #  @apps = App.all
        #end
        @applications = @job.applications

        if @applications.count == 0
          render json: { errors: ["Empty."] }, status: 400 and return
        end

        if !@page_no.to_i.between?(1,((@applications.count.to_f/ITEMS_PER_PAGE).ceil))
          render json: { errors: ["Invalid page number."] }, status: 400 and return
        end

        @last_page_value = @page_no == (@applications.count.to_f/ITEMS_PER_PAGE).ceil
        @applications = @applications.offset((@page_no - 1) * ITEMS_PER_PAGE).limit(ITEMS_PER_PAGE)
        #if params[:query].present?
        #  render json: { :query => params[:query], :last => @last_page_value, :data => @apps.as_json(:only => [:id, :name, :logo], :include => {:developer => {:only => [:username]}}) } and return
        #else
          render json: { :last => @last_page_value, :data => @applications.as_json(:except => [:deleted_at]) } and return
        #end
      end

      def create
        @application = Application.new(application_params)
        @application.job = @job

        if @application.save
          render json: @application.as_json(:except => [:deleted_at])
        else
           render json: { errors: ["Invalid attributes."] }, status: 400
        end
      end

      private

      def set_organisation
        begin
          @organisation = Organisation.find(params[:organisation_id])
        rescue
          render status: :not_found, json: { errors: ["Not Found."] }
        end
      end

      def set_job
        begin
          @job = Job.find(hashid_from_param(params[:job_id]))
        rescue
          render status: :not_found, json: { errors: ["Not Found."] }
        end
      end

      def set_application
        begin
          @application = Application.find(params[:id])
        rescue
          render status: :not_found, json: { errors: ["Not Found."] }
        end
      end

      def application_params
        params.require(:application).permit(:name, :description)
      end

    end
  end
end