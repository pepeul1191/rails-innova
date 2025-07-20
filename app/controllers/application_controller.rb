class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  layout "blank"
  private

  def redirect_if_authenticated
    if session[:user_type].present?
      redirect_to root_path, alert: "Ya has iniciado sesión."
    end
  end

  def not_found(exception = nil)
    Rails.logger.info '-------------------------------------------------'

    'XD'
  end
end
