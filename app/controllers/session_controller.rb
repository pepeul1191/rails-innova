require 'httparty'

class SessionController < ApplicationController
  # skip_before_action :verify_authenticity_token, only: [:sign_in]
  skip_before_action :verify_authenticity_token, only: [:google_oauth2]

  def sign_in
    render "session/sign-in"
  end

  def sign_up
    render "session/sign-up"
  end

  def reset_password
    render "session/reset-password"
  end

  def login
    # Aquí recibes los datos del formulario
    email = params[:email]
    password = params[:password]

    # Ejemplo simple de validación
    if email == "innova@ulima.edu.pe" && password == "123456"
      # Redirigir si es correcto
      redirect_to root_path, notice: "Inicio de sesión exitoso"
    else
      # Redirigir con mensaje de error
      redirect_to sign_in_path, alert: "Correo o contraseña incorrectos"
    end
  end

  def google_oauth2
    auth = request.env['omniauth.auth']
    if auth && auth.info
      # Almacenar información del usuario en la sesión
      session[:user] = {
        email: auth.info.email,
        name: auth.info.name,
        provider: auth.provider,
        uid: auth.uid,
        access_token: auth.credentials.token # Store access token for logout
      }
      redirect_to root_path, notice: "Inicio de sesión con Google exitoso"
    else
      redirect_to sign_in_path, alert: "Error al autenticar con Google"
    end
  end

  def get_session
    render json: {
      status: 'success',
      message: 'Sesón Activa',
      user: session[:user]
    }, status: :ok 
  end

  def logout
    if session[:user] && session[:user][:access_token]
      # Revoke Google OAuth token
      response = HTTParty.post(
        'https://accounts.google.com/o/oauth2/revoke',
        query: { token: session[:user][:access_token] }
      )
      unless response.success?
        Rails.logger.warn "Failed to revoke Google token: #{response.body}"
      end
    end

    # Clear the session
    reset_session

    render json: {
      status: 'success',
      message: 'Sesión cerrada exitosamente'
    }, status: :ok
  end

  def failure
    redirect_to sign_in_path, alert: "Error al autenticar con Google"
  end
end
