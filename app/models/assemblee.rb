class Assemblee < ApplicationRecord
  has_many :presences

  after_save :update_fin

  scope :ordered, -> { order(début: :desc) }

  private

  def update_fin
    self.update_column(:fin, self.début + self.durée.to_f.hours)
  end
end
