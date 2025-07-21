Rails.application.config.middleware.use Rack::Cors do
  allow do
    origins ENV['BASE_URL'] # ✅ Añade el origen desde donde haces la petición

    resource '/api/v1/*',
      headers: [:content_type, :authorization],
      methods: [:get, :post, :put, :patch, :delete, :options],
      credentials: true
  end
end