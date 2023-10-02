# NOT IN USE
module JwtWrapper
  extend ActiveSupport::Concern
  SECRET_KEY = Rails.application.credentials.devise_jwt_secret_key

  def jwt_encode(payload)
    payload[:exp] = 30.minutes.to_i
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def jwt_decode(token)
    JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')
  rescue JWT::DecodeError
    nil
  end
end

