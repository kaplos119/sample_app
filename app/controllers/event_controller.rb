class EventController < ApplicationController

  before_action :user_logged_in?
  
  def create
    response, code = Iterable::EventHandler.new(current_user, permitted_params['event_name']).create_event
    if code == 'Success'
      render json: response, status: :ok
    else
      render json: response, status: :forbidden
    end
  rescue Iterable::UnknownEventException => error
    render json: error.error_message, status: :bad_request
  rescue Iterable::RequestError => error
    render json: error.error_message, status: :forbidden
  rescue StandardError => error
    Rails.logger.error("Something went wrong ===> #{error}")
    render json: "Something went wrong", status: :internal_server_error
  end

  private

  def permitted_params
    params.permit(:event_name)
  end

  def user_logged_in?
    render json: "User not logged in", status: :unauthorized if current_user.blank?
  end
end