class Participant < ApplicationRecord
  normalizes :nom, with: -> nom { nom.upcase.strip }
  normalizes :prénom, with: -> prénom { prénom.humanize.strip }

  scope :ordered, -> { order(:nom) }

  def nom_prénom
    "#{self.nom} #{self.prénom}"
  end
end
