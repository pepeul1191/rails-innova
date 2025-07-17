class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def not_found(exception = nil)
    response.status = 404
    if request.get?
      render "not_found"
    else
      render json: {
        error: 'Not Found',
        path: request.fullpath,
        message: exception&.message || 'The requested resource was not found'
      }, status: :not_found
    end
  end
end
