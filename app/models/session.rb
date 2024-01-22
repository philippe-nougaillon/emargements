class Session < ApplicationRecord
  has_many :presences

  scope :ordered, -> { order(date: :desc) }
end
