class Presence < ApplicationRecord
  audited

  belongs_to :user
  belongs_to :assemblee

  validates :user_id, uniqueness: {scope: :assemblee_id, message: "Une seule signature par assemblée !" } 
  validate :check_heure

  encrypts :signature

  scope :ordered, -> { order(heure: :desc) }

  after_create_commit -> { broadcast_prepend_to "presences_#{self.assemblee.organisation.slug}", 
                                                partial: "presences/presence", 
                                                locals: { presence: self }, 
                                                target: "presences" }

  after_create_commit -> { broadcast_replace_to "presences_count_#{self.assemblee.organisation.slug}", 
                                                partial: "presences/presences_count", 
                                                locals: { presences_count: self.assemblee.presences.count }, 
                                                target: "presences_count" }


  def check_heure
    if !(Time.current > self.assemblee.début - 10.minutes && Time.current < (self.assemblee.début + self.assemblee.durée.to_f.hours))
      self.errors.add :erreur, ": Le délai imparti a expiré !" 
    end
  end

  def check_conflit
    # Check si des assemblées se passent au même moment, et si un participant a signé sur deux de ces assemblées 
    assemblees = self.assemblee.organisation.assemblees.tagged_with(self.user.tags, any: true).where("(assemblees.début BETWEEN :debut AND :fin) OR (assemblees.fin BETWEEN :debut AND :fin) OR (:debut BETWEEN assemblees.début AND assemblees.fin)", {debut: self.assemblee.début, fin: self.assemblee.fin})
    return [((assemblees.count > 1)? assemblees.pluck(:id) : false) , (assemblees.joins(:presences).where('presences.user_id': self.user_id).count > 1)]
  end
  
end
