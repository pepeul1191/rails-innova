class NewsItemsController < ApplicationController
  layout "application"
  # Validar antes de mostrar las vistas de site

  def index
    @link = '/news-items'
    # Parámetros
    @title = params[:title]
    @subtitle = params[:subtitle]
    @init_date = params[:init_date]
    @end_date = params[:end_date]
    @page = params[:page]&.to_i || 1
    @per_page = params[:per_page]&.to_i || 10

    # Consulta base
    query = NewsItem.all

    # Filtro por nombre
    if @title.present?
      query = query.where("title LIKE ?", "%#{@title}%")
    end

    if @subtitle.present?
      query = query.where("subtitle LIKE ?", "%#{@subtitle}%")
    end

    # Filtro por rango de fechas
    if @init_date.present? && @end_date.present?
      begin
        init = Date.parse(@init_date)
        end_date = Date.parse(@end_date)

        if end_date >= init
          query = query.where(published: init..end_date)
        else
          flash.now[:alert] = "La fecha final debe ser mayor o igual a la inicial."
        end
      rescue ArgumentError
        flash.now[:alert] = "Formato de fecha inválido."
      end
    end
    # Contar total
    @total = query.count

    # Calcular total de páginas
    @pages = (@total / @per_page.to_f).ceil

    # Paginación
    @news_items = query.paginate(page: @page, per_page: @per_page)
  end

  def new
    @link = '/news-items'
  end

  def create
    # Action
    title = params[:title]
    subtitle = params[:subtitle]
    image_url = params[:image_url]
    published = params[:published]
    content = params[:content]

    @news_item = NewsItem.new(
      title: title,
      subtitle: subtitle,
      image_url: image_url.presence || 'uploads/news-items/default.jpg',
      published: published,
      content: content,
    )

    begin
      if @news_item.save
        @news_item.url = "#{@news_item.id}-#{@news_item.title.parameterize}"
        @news_item.save
        redirect_to '/news-items', notice: "Noticia creada correctamente"
      else
        flash.now[:alert] = "Hay errores en el formulario"
        render :new
      end
    rescue => e
      # Captura cualquier error general
      Rails.logger.error "Error al crear noticia: #{e.message}"
      flash.now[:alert] = "Ocurrió un error inesperado: #{e.message}"
      render :new
    end
  end

  def delete
    begin
      @news_item = NewsItem.find(params[:id])
      if @news_item.destroy
        redirect_to '/news-items', notice: "Noticia eliminada"
      else
        redirect_to '/news-items', alert: "No se pudo eliminar"
      end
    rescue ActiveRecord::RecordNotFound
      # Si no se encuentra el registro, redirige a una página 404
      redirect_to not_found_path
    rescue => e
      # Captura cualquier error general
      Rails.logger.error "Error al eleminar noticia: #{e.message}"
      flash.now[:alert] = "Ocurrió un error inesperado: #{e.message}"
      render :index
    end
  end

  def edit
    begin
      @news_item = NewsItem.find(params[:id])
      @link = '/news-items'
      render :edit
    rescue ActiveRecord::RecordNotFound
      # Si no se encuentra el registro, redirige a una página 404
      redirect_to not_found_path
    rescue => e
      # Captura cualquier error general
      Rails.logger.error "Error al eleminar noticia: #{e.message}"
      flash.now[:alert] = "Ocurrió un error inesperado: #{e.message}"
      render :index
    end
  end

  def update
    @news_item = NewsItem.find_by(id: params[:id])
  
    if @news_item.nil?
      redirect_to not_found_path, alert: "Noticia no encontrada"
      return
    end
  
    title = params[:title]
    subtitle = params[:subtitle]
    image_url = params[:image_url]
    published = params[:published]
    content = params[:content]
  
    if @news_item.update(
      title: title,
      subtitle: subtitle,
      image_url: image_url.presence || 'uploads/news-items/default.jpg',
      published: published,
      content: content,
    )
      redirect_to "/news-items/#{params[:id]}/edit", notice: "Noticia actualizada"
    else
      flash.now[:alert] = "No se pudo actualizar"
      render :edit
    end
  end
end
