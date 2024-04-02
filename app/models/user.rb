class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :registerable, :lockable, and :omniauthable

  devise  :database_authenticatable,
          :recoverable,
          :rememberable,
          :validatable,
          :trackable,
          :timeoutable

  acts_as_taggable_on :tags

  has_many :presences

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
