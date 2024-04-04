class MailLog < ApplicationRecord
  belongs_to :organisation

  scope :ordered, -> { order('mail_logs.created_at DESC') }
end
