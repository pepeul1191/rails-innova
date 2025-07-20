class SpecialismsController < ApplicationController
  layout "application"
  # Validar antes de mostrar las vistas de site

  def index
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
end
