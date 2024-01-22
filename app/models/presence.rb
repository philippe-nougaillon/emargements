class Presence < ApplicationRecord
  belongs_to :participant
  belongs_to :session

  scope :ordered, -> { order(heure: :desc) }
end
