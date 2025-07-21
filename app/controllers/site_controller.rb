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
      @mentors = Mentor.includes(:specialisms).all
      puts '1 +++++++++++++++++++++++++++++++++++++++'
      puts @mentors.to_json
      puts '2 +++++++++++++++++++++++++++++++++++++++'
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

  def determine_layout
    # Si el usuario es admin, usa el layout por defecto (application)
    if session[:user_type].present?
      'application'
    else
      'site'
    end
  end
end
