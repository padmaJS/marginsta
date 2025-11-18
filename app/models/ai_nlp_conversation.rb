class AiNlpConversation < ApplicationRecord
  belongs_to :user

  validates :query, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :for_user, ->(user) { where(user: user) }

  def success?
    error.blank?
  end

  def failed?
    error.present?
  end
end
