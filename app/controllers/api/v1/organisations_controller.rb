module Api
  module V1
    class OrganisationsController < ApplicationController
      before_action :set_organisation, only: [:update, :destroy, :show]

      ITEMS_PER_PAGE = 10

      def show
        render json: @organisation.as_json(:except => [:deleted_at])
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
        @organisations = Organisation.all

        if @organisations.count == 0
          render json: { errors: ["Empty."] }, status: 400 and return
        end

        if !@page_no.to_i.between?(1,((@organisations.count.to_f/ITEMS_PER_PAGE).ceil))
          render json: { errors: ["Invalid page number."] }, status: 400 and return
        end

        @last_page_value = @page_no == (@organisations.count.to_f/ITEMS_PER_PAGE).ceil
        @organisations = @organisations.offset((@page_no - 1) * ITEMS_PER_PAGE).limit(ITEMS_PER_PAGE)
        #if params[:query].present?
        #  render json: { :query => params[:query], :last => @last_page_value, :data => @apps.as_json(:only => [:id, :name, :logo], :include => {:developer => {:only => [:username]}}) } and return
        #else
          render json: { :last => @last_page_value, :data => @organisations.as_json(:except => [:deleted_at]) } and return
        #end
      end

      def create
        @organisation = Organisation.new(organisation_params)

        if @organisation.save
          render json: @organisation.as_json(:except => [:deleted_at])
        else
           render json: { errors: ["Invalid attributes."] }, status: 400
        end
      end

      def update
        if @organisation.update(organisation_params)
          render json: @organisation.as_json(:except => [:deleted_at])
        else
          render json: { errors: ["Invalid attributes."] }, status: 400
        end
      end

      def destroy
        if @organisation.destroy
          render json: { messages: ["Deletion successful."] }, status: 200
        else
          render json: { errors: ["Deletion failed."] }, status: 500
        end
      end

      private

      def set_organisation
        begin
          @organisation = Organisation.find(params[:id])
        rescue
          render status: :not_found, json: { errors: ["Not Found."] }
        end
      end

      def organisation_params
        params.require(:organisation).permit(:name, :description)
      end

    end
  end
end