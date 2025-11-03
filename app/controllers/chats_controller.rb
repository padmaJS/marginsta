class ChatsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chats = current_user.chats.includes(:users, messages: :user).order("messages.created_at DESC")

    @suggested_users = current_user.followers & current_user.followers
  end

  def show
    @chat = Chat.includes(:users, messages: :user).find(params[:id])

    @message = Message.new
  end

  def create
    @chat = Chat.new(chat_params)
  end

  def start_with
    other_user = User.find(params[:user_id])
    @chat = Chat.between_users(current_user, other_user)

    unless @chat
      @chat = Chat.create!
      @chat.users << current_user
      @chat.users << other_user

    end

    redirect_to @chat
  end
end
