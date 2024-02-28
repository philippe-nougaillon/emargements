class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, and :omniauthable
  devise  :database_authenticatable,
          :registerable,
          :recoverable,
          :rememberable,
          :validatable,
          :trackable,
          :timeoutable


  normalizes :nom, with: -> nom { nom.upcase.strip }
  normalizes :prénom, with: -> prénom { prénom.humanize.strip }

  scope :ordered, -> { order(:nom) }

  def nom_prénom
    "#{self.nom} #{self.prénom}"
  end

  def prénom_nom
    "#{self.prénom} #{self.nom}"
  end
end
