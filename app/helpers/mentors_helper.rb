module MentorsHelper
  def self.get_mentors_with_specialisms(name = nil, specialism_id = nil)
     # Consulta base
      sql = <<~SQL
      SELECT 
        M.id, 
        M.full_name, 
        M.email, 
        M.image_url, 
        M.charge, 
        S.id AS specialism_id, 
        S.name AS specialism_name 
      FROM mentors_specialisms MS 
      INNER JOIN mentors M ON MS.mentor_id = M.id
      INNER JOIN specialisms S ON MS.specialism_id = S.id
      WHERE 1=1
    SQL

    conditions = []
    values = []

    if name.present?
      conditions << "LOWER(M.full_name) LIKE ?"
      values << "%#{name.downcase}%"
    end

    if specialism_id.present?
      conditions << "S.id = ?"
      values << specialism_id.to_i  # Asegúrate de que sea entero
    end

    if conditions.any?
      sql += " AND #{conditions.join(' AND ')}"
    end

    sql += " ORDER BY M.full_name, S.name"

    # === ¡CORRECCIÓN CLAVE AQUÍ! ===
    # sanitize_sql_array devuelve el SQL con las ? reemplazadas
    final_sql = ActiveRecord::Base.send(:sanitize_sql_array, [sql, *values])

    # Ejecutar con el SQL ya interpolado
    results = ActiveRecord::Base.connection.exec_query(final_sql)

    # Agrupa por mentor
    results.group_by { |row| row['id'] }.map do |mentor_id, rows|
      first_row = rows.first
      {
        id: mentor_id.to_i,
        full_name: first_row['full_name'],
        email: first_row['email'],
        image_url: first_row['image_url'],
        charge: first_row['charge'],
        specialisms: rows.map { |r| 
          { 
            id: r['specialism_id'].to_i, 
            name: r['specialism_name'] 
          } 
        }.uniq
      }
    end
  end
end
