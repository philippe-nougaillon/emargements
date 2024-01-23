class Assemblee < ApplicationRecord
  has_many :presences

  scope :ordered, -> { order(début: :desc) }
end
