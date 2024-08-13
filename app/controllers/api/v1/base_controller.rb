# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      include BaseHandler
      include ExceptionHandler
      include Authentication
      include SerializerHandler

      protected

      def index
        render json: resources, meta: pagination_meta(resources)
      end

      def create
        if new_resource.save
          render json: new_resource, status: :created
        else
          render json: { message: new_resource.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if resource.update(permitted_params)
          render json: resource
        else
          render json: { message: resource.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        if resource.destroy
          render json: resource
        else
          render json: { message: resource.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        render json: serialized_collection
      end

      def resources
        @resources ||= model.all.order(created_at: :desc).where(user: @current_user).page(params[:page]).per(params[:per_page] || 10)
      end

      def resource
        @resource ||= model.find(params[:id])
      end

      def new_resource
        @new_resource ||= model.new(permitted_params)
      end

      def serialized_collection
        serialize(resource, serializer)
      end

      def serializer
        "#{model.name}Serializer".constantize
      end

      def pagination_meta(collection)
        {
          current_page: collection.current_page,
          next_page: collection.next_page,
          prev_page: collection.prev_page,
          total_pages: collection.total_pages,
          total_count: collection.total_count
        }
      end
    end
  end
end
