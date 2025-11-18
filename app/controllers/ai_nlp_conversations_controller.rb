class AiNlpConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = current_user.ai_nlp_conversations.recent.limit(50)
    @conversation = AiNlpConversation.new
  end

  def create
    query = params[:ai_nlp_conversation][:query]

    if query.blank?
      flash[:alert] = "Please enter a question"
      return redirect_to ai_nlp_conversations_path
    end

    # Create conversation record
    @conversation = current_user.ai_nlp_conversations.new(query: query)

    begin
      # Call AI service
      result = AiNlp.ask_database(query)

      if result[:success]
        @conversation.sql_query = result[:sql_query]
        @conversation.response = result[:results].to_json
        @conversation.save!

        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.append("conversations", partial: "ai_nlp_conversations/user_message", locals: {conversation: @conversation}),
              turbo_stream.append("conversations", partial: "ai_nlp_conversations/ai_response", locals: {conversation: @conversation})
            ]
          end
          format.html { redirect_to ai_nlp_conversations_path }
        end
      else
        @conversation.error = result[:error]
        @conversation.sql_query = result[:sql_query]
        @conversation.save!

        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.append("conversations", partial: "ai_nlp_conversations/user_message", locals: {conversation: @conversation}),
              turbo_stream.append("conversations", partial: "ai_nlp_conversations/error_response", locals: {conversation: @conversation})
            ]
          end
          format.html { redirect_to ai_nlp_conversations_path }
        end
      end
    rescue => e
      @conversation.error = e.message
      @conversation.save

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("conversations", partial: "ai_nlp_conversations/user_message", locals: {conversation: @conversation}),
            turbo_stream.append("conversations", partial: "ai_nlp_conversations/error_response", locals: {conversation: @conversation})
          ]
        end
        format.html { redirect_to ai_nlp_conversations_path }
      end
    end
  end

  private

  def conversation_params
    params.require(:ai_nlp_conversation).permit(:query)
  end
end
