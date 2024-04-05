class User < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  audited

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, and :omniauthable

  devise  :database_authenticatable,
          :recoverable,
          :rememberable,
          :validatable,
          :trackable,
          :timeoutable,
          :registerable

  acts_as_taggable_on :tags

  belongs_to :organisation, optional: true
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

  def dispatch_email_to_nom_prénom
    nom_prénom = self.email.split('@').first
    if nom_prénom.include?('.')
      self.prénom, self.nom = nom_prénom.split('.')
    else
      self.nom = nom_prénom
    end
  end

  private
  def slug_candidates
    [SecureRandom.uuid]
  end
end
