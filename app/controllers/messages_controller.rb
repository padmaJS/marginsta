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

  private

  def set_chat
    @chat = Chat.find(params[:chat_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
