class MentorsController < ApplicationController
  layout "application"
  # Validar antes de mostrar las vistas de site

  def index
    @link = '/mentors'
    # Parámetros
    @name = params[:name]
    @code = params[:code]
    @email = params[:email]
    @page = params[:page]&.to_i || 1
    @per_page = params[:per_page]&.to_i || 10

    # Consulta base
    query = Mentor.select(:id, :code, :full_name, :email)

    # Filtros por nombre, codigo y correo
    if @name.present?
      query = query.where("full_name LIKE ?", "%#{@name}%")
    end
    
    if @code.present?
      query = query.where("code LIKE ?", "%#{@code}%")
    end
    
    if @email.present?
      query = query.where("email LIKE ?", "%#{@email}%")
    end

    # Contar total
    @total = query.size

    # Calcular total de páginas
    @pages = (@total / @per_page.to_f).ceil

    # Paginación
    @mentors = query.paginate(page: @page, per_page: @per_page)
  end

  def new
    @link = '/mentors'
  end
end