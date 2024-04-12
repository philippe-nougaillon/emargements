class Presence < ApplicationRecord
  audited

  belongs_to :user
  belongs_to :assemblee

  validate :check_heure

  encrypts :signature

  scope :ordered, -> { order(heure: :desc) }

  after_create_commit -> { broadcast_prepend_to "presences", 
                                                partial: "presences/presence", 
                                                locals: { presence: self }, 
                                                target: "presences" }

  def check_heure
    if !(Time.current > self.assemblee.début && Time.current < (self.assemblee.début + self.assemblee.durée.to_f.hours))
      self.errors.add :erreur, ": Le délai imparti a expiré !" 
    end
  end
  
end
