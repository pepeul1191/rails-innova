module MentorsHelper
  def self.get_mentors_with_specialisms
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
      ORDER BY M.id, S.name
    SQL

    # Ejecuta el query y convierte a array de hashes
    results = ActiveRecord::Base.connection.select_all(sql).to_a

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
