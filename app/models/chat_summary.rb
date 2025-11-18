class ChatSummary < ApplicationRecord
  belongs_to :chat

  validates :content, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
