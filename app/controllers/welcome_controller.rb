require 'httparty'

class WelcomeController < ApplicationController
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
end
