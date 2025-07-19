require 'httparty'

class SessionController < ApplicationController
  # skip_before_action :verify_authenticity_token, only: [:sign_in]

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
end
