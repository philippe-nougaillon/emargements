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

  acts_as_taggable_on :tags

  has_many :presences

  normalizes :nom, with: -> nom { nom.upcase.strip }
  normalizes :prénom, with: -> prénom { prénom.humanize.strip }

  encrypts :nom

  scope :ordered, -> { order(:nom) }

  def nom_prénom
    "#{self.nom} #{self.prénom}"
  end

  def prénom_nom
    "#{self.prénom} #{self.nom}"
  end
end
