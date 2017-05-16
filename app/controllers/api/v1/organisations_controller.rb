module Api
  module V1
    class OrganisationsController < ApplicationController

      def show
      end

      def index
        render json: { messages: ["Hi."] }
      end

      def create
      end

      def update
      end

      def destroy
      end

    end
  end
end