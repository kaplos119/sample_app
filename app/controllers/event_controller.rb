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
    render json: I18n.t('controllers.event.internal_error'), status: :internal_server_error
  end

  private

  # Make use of strong params
  def permitted_params
    params.permit(:event_name)
  end

  # Always check whether user is logged in or not before invoking iterable api's
  def user_logged_in?
    render json: I18n.t('controllers.event.unauthorized_user'), status: :unauthorized if current_user.blank?
  end
end