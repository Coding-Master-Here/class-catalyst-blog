class ApplicationController < ActionController::API
    include ActionController::HttpAuthentication::Token::ControllerMethods
  
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  
    private
  
    def record_not_found(exception)
      render json: { error: exception.message }, status: :not_found
    end
  end
  