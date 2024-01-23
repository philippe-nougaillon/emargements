class Presence < ApplicationRecord
  belongs_to :participant
  belongs_to :assemblee

  scope :ordered, -> { order(heure: :desc) }
end
