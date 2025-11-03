class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :user

  validates :content, presence: true

  after_create_commit :broadcast_message

  private

  def broadcast_message
		broadcast_append_to chat, target: "chat_#{chat.id}_messages", partial: "messages/message", locals: {message: self}
  end
end
