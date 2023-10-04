class ApplicationController < ActionController::API
  # include JwtWrapper

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name avatar])
  end

  def active_session
    if request.headers['Authorization'].present?
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.devise_jwt_secret_key!).first
      @current_user = User.find(jwt_payload['sub'])
    end

    if current_user
      current_user
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
