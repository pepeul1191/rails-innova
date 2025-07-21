class SlidersController < ApplicationController
  layout "application"
  # Validar antes de mostrar las vistas de site

  def index
    @link = '/sliders'
    # Parámetros
    @title = params[:title]
    @subtitle = params[:subtitle]
    @page = params[:page]&.to_i || 1
    @per_page = params[:per_page]&.to_i || 10

    # Consulta base
    query = Slider.all

    # Filtro por nombre
    if @title.present?
      query = query.where("title LIKE ?", "%#{@title}%")
    end

    if @subtitle.present?
      query = query.where("subtitle LIKE ?", "%#{@subtitle}%")
    end

    # Contar total
    @total = query.count

    # Calcular total de páginas
    @pages = (@total / @per_page.to_f).ceil

    # Paginación
    @sliders = query.paginate(page: @page, per_page: @per_page)
  end

  def new
    @link = '/sliders'
  end

  def create
    # Action
    title = params[:title]
    subtitle = params[:subtitle]
    image_url = params[:image_url]
    activity_url = params[:activity_url]

    @slider = Slider.new(
      title: title,
      subtitle: subtitle,
      image_url: image_url.presence || 'uploads/sliders/default.webp',
      activity_url: image_url.presence || '',
    )

    begin
      if @slider.save
        redirect_to '/sliders', notice: "Slider creada correctamente"
      else
        flash.now[:alert] = "Hay errores en el formulario"
        render :new
      end
    rescue => e
      # Captura cualquier error general
      Rails.logger.error "Error al crear slider: #{e.message}"
      flash.now[:alert] = "Ocurrió un error inesperado: #{e.message}"
      render :new
    end
  end

  def delete
    begin
      @slider = Slider.find(params[:id])
      if @slider.destroy
        redirect_to '/sliders', notice: "Slider eliminada"
      else
        redirect_to '/sliders', alert: "No se pudo eliminar"
      end
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

  def edit
    begin
      @slider = Slider.find(params[:id])
      @link = '/sliders'
      render :edit
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

  def update
    @slider = Slider.find_by(id: params[:id])
  
    if @slider.nil?
      redirect_to not_found_path, alert: "Slider no encontrada"
      return
    end
  
    title = params[:title]
    subtitle = params[:subtitle]
    image_url = params[:image_url]
    activity_url = params[:activity_url]
  
    if @slider.update(
      title: title,
      subtitle: subtitle,
      image_url: image_url.presence || 'uploads/sliders/default.jpg',
      activity_url: activity_url,
    )
      redirect_to "/sliders/#{params[:id]}/edit", notice: "Slider actualizada"
    else
      flash.now[:alert] = "No se pudo actualizar"
      render :edit
    end
  end
end
