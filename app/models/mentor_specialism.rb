class MentorSpecialism < ApplicationRecord
  self.table_name = 'mentors_specialisms'

  # Relaciones
  belongs_to :mentor
  belongs_to :specialism

  # Validaciones
  validates :mentor_id, presence: true
  validates :specialism_id, presence: true
end