require 'httparty'

class WelcomeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:sign_in]

  def index
    render "welcome/index"
  end

  def show
    begin
      response = HTTParty.get("http://localhost:9292/apis/v1/tags", timeout: 5) 
      # Si hay respuesta, pasamos el status y body tal cual
      status_code = response.code
      response_body = response.body
      render json: response_body, status: status_code
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
           Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      # Manejamos cualquier error de conexión o timeout
      render json: { error: "No se pudo conectar con la API externa", message: e.message }, status: :service_unavailable
    end
  end

  def sign_in
    # Recibir los datos del formulario
    username = params[:username]
    password = params[:password]

    # Hacer petición a tu API con HTTParty
    begin
      access_response = HTTParty.post(
        'http://localhost:8080/api/v1/sign-in', # Reemplaza con tu URL
        body: {
          username: username,
          password: password,
          system_id: 1
        }.to_json,
        headers: {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
        }
      )
      file_server_response = HTTParty.post(
        'http://localhost:8090/api/v1/sign-in', # Reemplaza con tu URL
        body: {}.to_json,
        headers: {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'X-Auth-Trigger' => 'dXNlci1zdGlja3lfc2VjcmV0XzEyMzQ1Njc'
        }
      )
      # Manejar la respuesta
      status_code = access_response.code
      response_body = JSON.parse(access_response.body)
      file_server_status_code = file_server_response.code
      file_server_response_body = JSON.parse(file_server_response.body)
      puts '1 +++++++++++++++++++++++++++'
      puts file_server_response_body['token']
      puts '2 +++++++++++++++++++++++++++'
      response_body['file_token'] = file_server_response_body['token']
      # response_body[:hola] = 'mundo'
      render json: response_body, status: status_code
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
      Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      # Manejamos cualquier error de conexión o timeout
      render json: { error: "No se pudo conectar con la API externa", message: e.message }, status: :service_unavailable
    end
  end
end
