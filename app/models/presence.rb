class Presence < ApplicationRecord
  validates :nom, :prénom, :heure, presence: true
end
