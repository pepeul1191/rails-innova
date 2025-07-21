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

  def create
    # Action
    code = params[:code]
    full_name = params[:full_name]
    charge = params[:charge]
    email = params[:email]
    linkedln_url = params[:linkedln_url]
    image_url = params[:image_url].presence || 'uploads/mentors/default.png'

    now = Time.now

    @mentor = Mentor.new(
      code: code,
      full_name: full_name,
      charge: charge,
      email: email,
      email: email,
      linkedln_url: linkedln_url,
      image_url: image_url,
      created: now,
      updated: now
    )

    begin
      if @mentor.save
        redirect_to '/mentors/' + @mentor.id.to_s + '/edit', notice: "Mentor creado correctamente"
      else
        flash.now[:alert] = "Hay errores en el formulario"
        render :new
      end
    rescue => e
      # Captura cualquier error general
      Rails.logger.error "Error al crear mentor: #{e.message}"
      flash.now[:alert] = "Ocurrió un error inesperado: #{e.message}"
      render :new
    end
  end

  def delete
    begin
      @mentor = Mentor.find(params[:id])
      if @mentor.destroy
        redirect_to mentors_path, notice: "Mentor eliminado"
      else
        redirect_to mentors_path, alert: "No se pudo eliminar"
      end
    rescue ActiveRecord::RecordNotFound
      # Si no se encuentra el registro, redirige a una página 404
      redirect_to not_found_path
    rescue => e
      # Captura cualquier error general
      Rails.logger.error "Error al eleminar el mentor: #{e.message}"
      flash.now[:alert] = "Ocurrió un error inesperado: #{e.message}"
      render :index
    end
  end

  def edit
    begin
      @mentor = Mentor.find(params[:id])
      @link = '/mentors'

      @specialisms = Specialism.joins("LEFT JOIN mentors_specialisms ms ON ms.specialism_id = specialisms.id AND ms.mentor_id = #{params[:id]}").select("specialisms.*, ms.mentor_id IS NOT NULL AS assigned")

      render :edit
    rescue ActiveRecord::RecordNotFound
      # Si no se encuentra el registro, redirige a una página 404
      redirect_to not_found_path
    rescue => e
      # Captura cualquier error general
      Rails.logger.error "Error al editar Mentor: #{e.message}"
      flash.now[:alert] = "Ocurrió un error inesperado: #{e.message}"
      render :index
    end
  end

  def update
    @mentor = Mentor.find_by(id: params[:id])
  
    if @mentor.nil?
      redirect_to not_found_path, alert: "Mentor no encontrado"
      return
    end
  
    code = params[:code]
    full_name = params[:full_name]
    charge = params[:charge]
    email = params[:email]
    linkedln_url = params[:linkedln_url]
    image_url = params[:image_url].presence || 'uploads/mentors/default.png'
  
    if @mentor.update(
      code: code,
      full_name: full_name,
      charge: charge,
      email: email,
      linkedln_url: linkedln_url,
      image_url: image_url,
    )
      redirect_to mentors_path, notice: "Mentor actualizado"
    else
      flash.now[:alert] = "No se pudo actualizar"
      render :edit
    end
  end

  def update_specialisms
    mentor_id = params[:mentor_id]
    specialism_ids = params[:specialism_ids] || []
    # Eliminar asociaciones anteriores
    MentorSpecialism.where(mentor_id: mentor_id).destroy_all
    # Crear nuevas asociaciones
    specialism_ids.each do |id|
      MentorSpecialism.create(mentor_id: mentor_id, specialism_id: id)
    end
  
    redirect_to mentors_path, notice: "Especialidades actualizadas correctamente"
  end

  def new
    @link = '/mentors'
  end
end