class Presence < ApplicationRecord
  belongs_to :user
  belongs_to :assemblee

  validate :check_heure

  scope :ordered, -> { order(heure: :desc) }

  def check_heure
    if !(Time.current > self.assemblee.début && Time.current < (self.assemblee.début + self.assemblee.durée.to_f.hours))
      self.errors.add :erreur, ": Le délai imparti a expiré !" 
    end
  end
end
