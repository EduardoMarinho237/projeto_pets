class ApplicationController < ActionController::API
  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    decoded_token = decode_jwt(token)

    if decoded_token
      @current_user = User.find_by(id: decoded_token[:user_id])
    else
      render json: { error: 'Não autorizado' }, status: :unauthorized
    end
  end

  private

  def decode_jwt(token)
    return nil unless token

    begin
      decoded = JWT.decode(token, Rails.application.secrets.secret_key_base, true, { algorithm: 'HS256' })
      decoded[0].symbolize_keys
    rescue JWT::DecodeError
      nil
    end
  end
end
