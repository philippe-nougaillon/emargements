class Organisation < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  has_one_attached :logo

  has_many :users
  has_many :assemblees

  validates :nom, presence: true

  def step
    if self.nom.include?('Mon_organisation')
      0
    elsif !(self.users.count > 1)
      1
    elsif !self.assemblees.any?
      2
    elsif self.assemblees.count == 1
      3
    else
      4
    end

  end

  private
  def slug_candidates
    [SecureRandom.uuid]
  end
end
