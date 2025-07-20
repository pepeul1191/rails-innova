class SpecialismController < ApplicationController
  layout "application"
  # Validar antes de mostrar las vistas de site

  def index
    @specialisms = Specialism.all
  end
end
