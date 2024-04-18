class Presence < ApplicationRecord
  audited

  belongs_to :user
  belongs_to :assemblee

  validate :check_heure

  encrypts :signature

  scope :ordered, -> { order(heure: :desc) }

  after_create_commit -> { broadcast_prepend_to "presences_#{self.assemblee.organisation.slug}", 
                                                partial: "presences/presence", 
                                                locals: { presence: self }, 
                                                target: "presences" }

  def check_heure
    if !(Time.current > self.assemblee.début && Time.current < (self.assemblee.début + self.assemblee.durée.to_f.hours))
      self.errors.add :erreur, ": Le délai imparti a expiré !" 
    end
  end

  def check_chevauchement
    # Check si un participant a signé sur deux assemblées qui ont lieu en même temps 
    assemblees = self.assemblee.organisation.assemblees.where("(assemblees.début BETWEEN :debut AND :fin) OR (assemblees.fin BETWEEN :debut AND :fin) OR (:debut BETWEEN assemblees.début AND assemblees.fin)", {debut: self.assemblee.début, fin: self.assemblee.fin})
    return (assemblees.joins(:presences).where('presences.user_id': self.user_id).count > 1)
  end
  
end
