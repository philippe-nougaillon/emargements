class Presence < ApplicationRecord
  belongs_to :participant
  belongs_to :session
end
