class ChatSummariesController < ApplicationController
  before_action :set_chat
  before_action :ensure_authorized

  def create
    recent_messages = @chat.last_n_messages(20)

    if recent_messages.empty?
      return render_error("No messages to summarize")
    end

    begin
      # Generate summary using our service
      summary_content = AiSummarizer.summarize_conversation(recent_messages)

      # Save to database
      @chat_summary = @chat.chat_summaries.create!(
        content: summary_content,
        message_count: recent_messages.count,
        summary_type: "last_20_messages"
      )
    rescue AiSummarizer::SummarizationError => e
      render_error("Failed to generate summary: #{e.message}")
    end
  end

  def index
    @summaries = @chat.chat_summaries.recent
    respond_to do |format|
      format.html
      format.json { render json: @summaries }
    end
  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:chat_id])
  end

  def ensure_authorized
    # Ensure user has access to this chat
    unless @chat.users.include?(current_user)
      render json: {error: "Not authorized"}, status: :forbidden
    end
  end

  def render_error(message)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append(
          "chat_#{@chat.id}_summaries",
          partial: "shared/error",
          locals: {message: message}
        )
      end
      format.json { render json: {error: message}, status: :unprocessable_entity }
    end
  end
end
