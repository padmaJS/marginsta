class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat

  def create
    @message = @chat.messages.build(message_params.merge(user: current_user))

    if @message.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @chat }
      end
    else
      render :new
    end
  end

  def delete_for_self
    @message = @chat.messages.find(params[:id])
    @message.update(removed_for_self: true)
    @message.removed_for_user_ids << current_user.id
    @message.save

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @chat }
    end
  end

  def delete_for_all
    @message = @chat.messages.find(params[:id])
    if @message.user == current_user
      @message.update(removed_for_everyone: true)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @chat }
      end
    else
      head :forbidden
    end
  end

  def actions
    @message = @chat.messages.find(params[:id])
  end

  private

  def set_chat
    @chat = Chat.find(params[:chat_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
