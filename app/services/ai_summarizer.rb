class AiSummarizer
  class SummarizationError < StandardError; end

  def self.summarize_conversation(messages, options = {})
    return "No messages to summarize" if messages.blank?

    client = RubyLLM.chat(provider: :ollama, model: "llama3.2:latest")
    prompt = build_prompt(messages, options)

    begin
      client.with_instructions system_prompt

      response = client.ask(prompt)

      response.content.strip
    rescue => e
      raise SummarizationError, "AI service error: #{e.message}"
    end
  end

  def self.system_prompt(options = {})
    <<~PROMPT
      You are a helpful assistant that summarizes conversations concisely.
      Focus on the main topics, decisions, and action items.
      Keep summaries to 2-3 sentences maximum.
      Be objective and avoid adding your own opinions.
      Format the response in clear, readable text.
    PROMPT
  end

  def self.build_prompt(messages, options = {})
    conversation_text = messages.map do |message|
      "#{message.user.user_name}: #{message.content}"
    end.join("\n")

    <<~PROMPT
      Please provide a concise summary of the following conversation:
      
      #{conversation_text}
    PROMPT
  end

  private_class_method :build_prompt, :system_prompt
end
