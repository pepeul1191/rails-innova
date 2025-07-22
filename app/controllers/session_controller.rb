require 'httparty'

class SessionController < ApplicationController
  # skip_before_action :verify_authenticity_token, only: [:sign_in]
  skip_before_action :verify_authenticity_token, only: [:google_oauth2]
   # Usamos el layout 'site.html.erb'
  layout "blank"
  # Validar antes de mostrar las vistas de login
  before_action :redirect_if_authenticated, only: [:sign_in, :sign_up, :reset_password]

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
    if email == "innova@ulima.edu.pe"
      # Redirigir si es correcto
      result = SessionHelper.login(email, password)
      # puts '1 ++++++++++++++++++++++++++++++++++'
      # puts result
      # puts '2 ++++++++++++++++++++++++++++++++++'
      if result[:status] == 200 then
        session[:user_type] = 'admin'
        session[:user] = {
          id: result[:body][:id],
          username: result[:body][:username],
          email: "innova@ulima.edu.pe",
          name: "Innova Admin",
          image: "/images/admin-user.png",
        }
        session[:tokens] = {
          access: result[:body][:access_token],
          files: result[:body][:files_token],
        }
        redirect_to root_path, notice: "Inicio de sesión exitoso"
      elsif result[:status] == 404 then
        redirect_to sign_in_path, alert: "Correo o contraseña incorrectos"
      else
        redirect_to sign_in_path, alert: result[:body][:error]
      end
    else
      # Redirigir con mensaje de error
      redirect_to sign_in_path, alert: "Correo o contraseña incorrectos"
    end
  end

  def google_oauth2
    auth = request.env['omniauth.auth']
    if auth && auth.info
      # Almacenar información del usuario en la sesión
      if auth.info.email.end_with?("@unmsm.edu.pe", "@aloe.ulima.edu.pe")
        session[:user_type] = 'student'
      else
        session[:user_type] = 'worker'
      end

      session[:user] = {
        email: auth.info.email,
        name: auth.info.name,
        provider: auth.provider,
        image: auth.info.image,
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
      user: session[:user],
      user_type: session[:user_type],
      tokens: session[:tokens],
    }, status: :ok 
  end

  def tokens
    if session[:tokens].present?
      render json: {
        tokens: session[:tokens]
      }, status: :ok
    else
      render json: {
        error: "No se encontraron tokens",
        message: "La sesión no contiene tokens de autenticación."
      }, status: 500
    end
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

    render :'sign-out'
  end

  def failure
    redirect_to sign_in_path, alert: "Error al autenticar con Google"
  end
end
