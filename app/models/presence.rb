class Presence < ApplicationRecord
  validates :nom, :prénom, :heure, :signature, presence: true
end
