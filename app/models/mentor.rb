# app/models/mentor.rb
class Mentor < ApplicationRecord
  has_many :mentor_specialisms
  has_many :specialisms, through: :mentor_specialisms
end