module SessionHelper
  def self.login(username, password)
    answer = { body: {}, status: 200 }

    begin
      # Configuración de variables de entorno
      url_access = ENV['URL_ACCESS_SERVICE']
      x_auth_access = ENV['X_AUTH_ACCESS_SERVICE']

      # Petición al servicio de autenticación
      access_response = HTTParty.post(
        "#{url_access}api/v1/sign-in/by-email",
        body: {
          email: username,
          password: password,
          system_id: ENV['SYSTEM_ID'].to_i
        }.to_json,
        headers: {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'X-Auth-Trigger' => x_auth_access
        }
      )

      if access_response.code == 200
        tmp = JSON.parse(access_response.body)
        answer[:body][:id] = tmp['id']
        answer[:body][:username] = tmp['username']
        answer[:body][:access_token] = tmp['token']
        answer[:body][:email] = tmp['email']

        # Petición al servicio de archivos
        url_files = ENV['URL_FILES_SERVICE']
        x_auth_files = ENV['X_AUTH_FILES_SERVICE']

        files_response = HTTParty.post(
          "#{url_files}api/v1/auth/generate-token",
          body: {
            user: {
              id: answer[:body][:id],
              username: answer[:body][:username],
              email: answer[:body][:email]
            }
          }.to_json,
          headers: {
            'Content-Type' => 'application/json',
            'Accept' => 'application/json',
            'X-Auth-Trigger' => x_auth_files
          }
        )

        if files_response.code == 200
          tmp1 = JSON.parse(files_response.body)
          answer[:body][:files_token] = tmp1['token']
        else
          tmp1 = JSON.parse(files_response.body)
          answer = {
            body: {
              error: tmp1['message'],
              message: 'Error al autenticarse con los servicios'
            },
            status: files_response.code
          }
        end

      else
        tmp = JSON.parse(access_response.body)
        answer = {
          body: {
            error: tmp['message'],
            message: tmp['error']
          },
          status: access_response.code
        }
      end

    rescue HTTParty::Error => e
      answer = {
        body: {
          error: 'No se pudo conectar con la API externa',
          message: e.message
        },
        status: 503
      }
    rescue JSON::ParserError => e
      answer = {
        body: {
          error: 'Error al procesar la respuesta del servidor',
          message: e.message
        },
        status: 500
      }
    rescue => e
      answer = {
        body: {
          error: 'Ocurrió un error al generar los JWTs',
          message: e.message
        },
        status: 500
      }
    end

    answer
  end
end