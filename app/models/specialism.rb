# app/models/specialism.rb
class Specialism < ApplicationRecord
  has_many :mentors_specialisms
  has_many :mentors, through: :mentors_specialisms
end