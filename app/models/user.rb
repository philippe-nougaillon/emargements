class User < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  audited

  # Include default devise modules. Others available are:
  # :lockable

  devise  :database_authenticatable,
          :recoverable,
          :rememberable,
          :validatable,
          :trackable,
          :timeoutable,
          :registerable,
          :confirmable,
          :omniauthable,
          omniauth_providers: [:google_oauth2]

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
    self.nom, self.prénom = nom_prénom.split('.')
  end

  def premium?
    self.organisation.premium?
  end

  def super_admin?
    %w[philippe.nougaillon@gmail.com pierreemmanuel.dacquet@gmail.com].include?(self.email)
  end

  def self.from_omniauth(auth)
    require "open-uri"

    if user = User.find_by(email: auth.info.email)
      user
    else
      find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.password_confirmation = user.password
        user.nom = auth.info.last_name   # assuming the user model has a name
        user.prénom = auth.info.first_name   # assuming the user model has a name
        user.organisation = Organisation.create(nom: "Mon_organisation")
        user.admin = true
        user.tag_list.add("Gestionnaire")

        # If you are using confirmable and the provider(s) you use validate emails, 
        # uncomment the line below to skip the confirmation emails.
        user.skip_confirmation!

        user.save

        user
      end
    end
  end

  private

  def slug_candidates
    [SecureRandom.uuid]
  end
end
