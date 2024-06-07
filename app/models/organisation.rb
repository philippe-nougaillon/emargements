class Organisation < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  audited

  has_one_attached :logo

  has_many :users
  has_many :assemblees
  has_many :presences, through: :assemblees
  has_many :mail_logs, dependent: :destroy

  validates :nom, presence: true

  def step
    if self.nom.include?('Mon_organisation')
      0
    elsif !(self.users.count > 1)
      1
    elsif !self.assemblees.any?
      2
    elsif self.assemblees.count == 1 && self.mail_logs.count.zero?
      3
    else
      4
    end
  end

  def tags
    assemblees_tags_ids = self.assemblees.tag_counts_on(:tags).pluck(:id)
    users_tags_ids = self.users.tag_counts_on(:tags).pluck(:id)
    return ActsAsTaggableOn::Tag.where(id: assemblees_tags_ids).or(ActsAsTaggableOn::Tag.where(id: users_tags_ids)).order(:name)
  end

  private
  def slug_candidates
    [SecureRandom.uuid]
  end
end
