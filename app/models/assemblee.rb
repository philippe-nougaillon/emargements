class Assemblee < ApplicationRecord
  extend FriendlyId
	friendly_id :slug_candidates, use: :slugged

  include Workflow
  include WorkflowActiverecord

  audited

  acts_as_taggable_on :tags

  belongs_to :user
  belongs_to :organisation
  has_many :presences, dependent: :destroy

  validates :nom, :début, :durée, presence: :true

  after_save :update_fin

  scope :ordered, -> { order(updated_at: :desc) }

  # WORKFLOW
  # 
    
  ATTENTE   = 'attente'
  EN_COURS  = 'en cours'
  COMPLET   = 'complet'
  INCOMPLET = 'incomplet'
  ARCHIVE   = 'archivé'

  workflow do
    state ATTENTE, meta: {style: 'badge badge-lg text-primary'}
    state EN_COURS, meta: {style: 'badge badge-lg text-error'}
    state COMPLET, meta: {style: 'badge badge-lg text-warning'}
    state INCOMPLET, meta: {style: 'badge badge-lg text-success'}
    state ARCHIVE, meta: {style: 'badge badge-lg text-secondary'}
  end

  # pour que le changement de 'workflow_state' se voit dans l'audit trail
  def persist_workflow_state(new_value)
    self[:workflow_state] = new_value
    save!
  end

  def self.workflow_state_humanized
    self.workflow_spec.states.keys.map{|i| i.to_s.humanize }
  end

  #
  # Decorators ------------------------------------
  #

  def style
    self.current_state.meta[:style]
  end

  def in_progress?
    (self.début < DateTime.now + 10.minutes) && (self.fin > DateTime.now)
  end

  def related_users
    ids = []
    self.tags.each do |tag|
      ids << self.organisation.users.tagged_with(tag).pluck(:id)
    end
    return ids.flatten.uniq
  end

  def qrcode(url)
    RQRCode::QRCode.new(url).as_svg(
                color: "000",
                shape_rendering: "crispEdges",
                module_size: 3,
                standalone: true,
                use_path: true)
  end

  def horaires
    "#{ I18n.l(self.début, format: "%d %b") } #{self.début.hour}h#{self.début.min unless self.début.min == 0} -> #{self.fin.hour}h#{self.fin.min unless self.fin.min == 0}"
  end

  def horaires_medium
    "#{I18n.l(self.début, format: "%A %d %b")} #{self.début.hour}h#{self.début.min unless self.début.min == 0} -> #{self.fin.hour}h#{self.fin.min unless self.fin.min == 0}"
  end

  def horaires_long
    "#{I18n.l(self.début, format: :custom2)} #{self.début.hour}h#{self.début.min unless self.début.min == 0} -> #{self.fin.hour}h#{self.fin.min unless self.fin.min == 0}"
  end

  def nom_long
    "#{self.nom} [#{self.horaires_medium}]"
  end

  def users_not_signed
    # Liste des utilisateurs des groupes de la sessino qui n'ont pas signé
    User.where(id: self.related_users)
        .where.not(id: self.presences.pluck(:user_id))
        .ordered
  end

  private

  def update_fin
    self.update_column(:fin, self.début + self.durée.to_f.hours)
  end

  def slug_candidates
		[SecureRandom.uuid]
	end
end
