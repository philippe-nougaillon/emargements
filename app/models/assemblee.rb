class Assemblee < ApplicationRecord
  extend FriendlyId
	friendly_id :slug_candidates, use: :slugged

  audited

  acts_as_taggable_on :tags

  belongs_to :user
  belongs_to :organisation
  has_many :presences, dependent: :destroy

  validates :nom, :début, :durée, presence: :true

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
      ids << self.organisation.users.tagged_with(tag).pluck(:id)
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
    "#{self.début.strftime("%d %b")} #{self.début.hour}h#{self.début.min unless self.début.min == 0} -> #{self.fin.hour}h#{self.fin.min unless self.fin.min == 0}"
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
