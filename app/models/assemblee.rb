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

  def in_progress?
    self.début < DateTime.now && self.fin > DateTime.now
  end

  def related_users
    ids = []
    self.tags.each do |tag|
      ids << User.tagged_with(tag).pluck(:id)
    end
    return ids.flatten.uniq
  end

  def qrcode(url)
    qrcode = RQRCode::QRCode.new(url)

    qrcode_svg = qrcode.as_svg(
                color: "000",
                shape_rendering: "crispEdges",
                module_size: 3,
                standalone: true,
                use_path: true,
          )
  end

  def horaires
    "#{I18n.l self.try(:début), format: :short}->#{self.try(:fin).try(:hour)}h#{self.try(:fin).try(:min)}"
  end

  def users_not_signed
    User.where(id: self.related_users).where.not(id: Presence.where(assemblee_id: self.id).pluck(:user_id)).ordered
  end

  private

  def update_fin
    self.update_column(:fin, self.début + self.durée.to_f.hours)
  end

  def slug_candidates
		[SecureRandom.uuid]
	end
end
