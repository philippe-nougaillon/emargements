class Assemblee < ApplicationRecord
  extend FriendlyId
	friendly_id :slug_candidates, use: :slugged

  acts_as_taggable_on :tags

  has_many :presences, dependent: :destroy
  belongs_to :user

  after_save :update_fin

  scope :ordered, -> { order(début: :desc) }

  def self.current
    Assemblee.where("NOW() BETWEEN assemblees.début AND assemblees.fin").first
  end

  def related_users
    ids = []
    self.tags.each do |tag|
      ids << User.tagged_with(tag).pluck(:id)
    end
    return ids.flatten.uniq
  end

  private

  def update_fin
    self.update_column(:fin, self.début + self.durée.to_f.hours)
  end

  def slug_candidates
		[SecureRandom.uuid]
	end
end
