class ApplicationController < ActionController::API
  rescue_from StandardError, with: :handle_internal_error
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid


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

  private

  def record_not_found(exception)
    puts "DEBUG: Exceção ActiveRecord::RecordNotFound capturada - #{exception.message}"
    render json: { error: 'Registro não encontrado', details: exception.message }, status: :not_found
  end  

  def record_invalid(exception)
    render json: { error: 'Dados inválidos', details: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  def handle_internal_error(exception)
    render json: { error: 'Erro interno no servidor', details: exception.message }, status: :internal_server_error
  end

end
