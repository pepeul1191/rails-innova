class SiteController < ApplicationController
  layout :determine_layout
  # Validar antes de mostrar las vistas de site
  before_action :redirect_if_authenticated, only: [:contact, :privacy, :terms, :about]

  def home
    if session[:user_type].present?
      # session[:user_type] existe y NO está vacío
      render :application
    else
      # session[:user_type] no existe o está vacío
      @sliders = Slider.all
      @new_items = NewsItem.order(published: :desc).limit(4)
      @mentors = MentorsHelper.get_mentors_with_specialisms
      render :home
    end
  end

  def contact
  end

  def privacy
  end

  def terms
  end

  def about
  end

  def news
    begin
      @new = NewsItem.find_by(url: params[:url])
      render :news
    rescue ActiveRecord::RecordNotFound
      # Si no se encuentra el registro, redirige a una página 404
      redirect_to not_found_path
    rescue => e
      # Captura cualquier error general
      Rails.logger.error "Error al eleminar slider: #{e.message}"
      flash.now[:alert] = "Ocurrió un error inesperado: #{e.message}"
      render :index
    end
  end

  def determine_layout
    # Si el usuario es admin, usa el layout por defecto (application)
    if session[:user_type].present?
      'application'
    else
      'site'
    end
  end
end
