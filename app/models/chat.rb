class Chat < ApplicationRecord
  has_many :chat_users, dependent: :destroy
  has_many :users, through: :chat_users
  has_many :messages, dependent: :destroy

  # validates :title, length: {maximum: 255}, allow_blank: false

  def other_user(current_user)
    users.where.not(id: current_user.id).first
  end

  def last_message(current_user)
    messages.order(created_at: :desc).select { |message| !(message.removed_for_self && message.removed_for_user_ids.include?(current_user.id)) && !message.removed_for_everyone }.first
  end

  def self.between_users(user1, user2)
    Chat.joins(:chat_users).where(chat_users: {user_id: [user1.id, user2.id]}).group("chats.id")
      .having("COUNT(chats.id) = 2").first
  end
end
