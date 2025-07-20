class SpecialismsController < ApplicationController
  layout "application"
  # Validar antes de mostrar las vistas de site

  def index
    @link = '/specialisms'
    # Parámetros
    @name = params[:name]
    @page = params[:page]&.to_i || 1
    @per_page = params[:per_page]&.to_i || 10

    # Consulta base
    query = Specialism.all

    # Filtro por nombre
    if @name.present?
      query = query.where("name LIKE ?", "%#{@name}%")
    end

    # Contar total
    @total = query.count

    # Calcular total de páginas
    @pages = (@total / @per_page.to_f).ceil

    # Paginación
    @specialisms = query.paginate(page: @page, per_page: @per_page)
  end

  def new
    @link = '/specialisms'
  end

  def create
    # Action
    name = params[:name]
    now = Time.now

    @specialism = Specialism.new(
      name: name,
      created: now,
      updated: now
    )

    begin
      if @specialism.save
        redirect_to specialisms_path, notice: "Especialidad creada correctamente"
      else
        flash.now[:alert] = "Hay errores en el formulario"
        render :new
      end
    rescue => e
      # Captura cualquier error general
      Rails.logger.error "Error al crear especialidad: #{e.message}"
      flash.now[:alert] = "Ocurrió un error inesperado: #{e.message}"
      render :new
    end
  end

  def delete
    begin
      @specialism = Specialism.find(params[:id])
      if @specialism.destroy
        redirect_to specialisms_path, notice: "Especialidad eliminada"
      else
        redirect_to specialisms_path, alert: "No se pudo eliminar"
      end
    rescue ActiveRecord::RecordNotFound
      # Si no se encuentra el registro, redirige a una página 404
      redirect_to not_found_path
    rescue => e
      # Captura cualquier error general
      Rails.logger.error "Error al eleminar especialidad: #{e.message}"
      flash.now[:alert] = "Ocurrió un error inesperado: #{e.message}"
      render :index
    end
  end

  def edit
    begin
      @specialism = Specialism.find(params[:id])
      @link = '/specialisms'
      render :edit
    rescue ActiveRecord::RecordNotFound
      # Si no se encuentra el registro, redirige a una página 404
      redirect_to not_found_path
    rescue => e
      # Captura cualquier error general
      Rails.logger.error "Error al eleminar especialidad: #{e.message}"
      flash.now[:alert] = "Ocurrió un error inesperado: #{e.message}"
      render :index
    end
  end

  def update
    @specialism = Specialism.find_by(id: params[:id])
  
    if @specialism.nil?
      redirect_to not_found_path, alert: "Especialidad no encontrada"
      return
    end
  
    name = params[:name]
  
    if @specialism.update(name: name)
      redirect_to specialisms_path, notice: "Especialidad actualizada"
    else
      flash.now[:alert] = "No se pudo actualizar"
      render :edit
    end
  end
end
