class AiNlp
  class QueryError < StandardError; end

  def self.ask_database(natural_language_query, options = {})
    client = RubyLLM.chat(provider: :ollama, model: "llama3.2:latest")

    schema = "
			Table: users
			- id (INTEGER, PK)
			- user_name (VARCHAR, Unique, NOT NULL)
			- email (VARCHAR, Unique, NOT NULL)
			- encrypted_password (VARCHAR, NOT NULL)
			- bio (TEXT)
			- profile_picture (VARCHAR)
			- created_at (DATETIME)
			- updated_at (DATETIME)

			Table: posts
			- id (INTEGER, PK)
			- user_id (BIGINT, FK to users)
			- caption (VARCHAR)
			- created_at (DATETIME)
			- updated_at (DATETIME)

			Table: comments
			- id (INTEGER, PK)
			- user_id (BIGINT, FK to users, NOT NULL)
			- post_id (BIGINT, FK to posts, NOT NULL)
			- content (TEXT)
			- created_at (DATETIME)
			- updated_at (DATETIME)

			Table: likes
			- id (INTEGER, PK)
			- user_id (BIGINT, FK to users, NOT NULL)
			- post_id (BIGINT, FK to posts, NOT NULL)
			- Unique Index: user_id + post_id (A user can only like a post once)
			- created_at (DATETIME)
			- updated_at (DATETIME)

			Table: follows
			- id (INTEGER, PK)
			- follower_id (BIGINT, FK to users, NOT NULL)
			- following_id (BIGINT, FK to users, NOT NULL)
			- Unique Index: follower_id + following_id
			- created_at (DATETIME)
			- updated_at (DATETIME)

			Table: chats
			- id (INTEGER, PK)
			- created_at (DATETIME)
			- updated_at (DATETIME)

			Table: chat_users (Join Table for Chats)
			- id (INTEGER, PK)
			- chat_id (BIGINT, FK to chats, NOT NULL)
			- user_id (BIGINT, FK to users, NOT NULL)
			- Unique Index: chat_id + user_id (A user can only be in a chat once)
			- created_at (DATETIME)
			- updated_at (DATETIME)

			Table: messages
			- id (INTEGER, PK)
			- chat_id (BIGINT, FK to chats, NOT NULL)
			- user_id (BIGINT, FK to users, NOT NULL)
			- content (TEXT, NOT NULL)
			- removed_for_self (BOOLEAN, default: false)
			- removed_for_everyone (BOOLEAN, default: false)
			- removed_for_user_ids (INTEGER[], ARRAY type for tracking specific removals)
			- created_at (DATETIME)
			- updated_at (DATETIME)

			Table: chat_summaries
			- id (INTEGER, PK)
			- chat_id (BIGINT, FK to chats, NOT NULL)
			- content (TEXT, NOT NULL)
			- message_count (INTEGER, default: 0)
			- summary_type (VARCHAR, default: 'last_20_messages')
			- created_at (DATETIME)
			- updated_at (DATETIME)
			"

    prompt = <<~PROMPT
      You are an expert SQL assistant. Based on the database schema below, generate a SQL query to answer the user's question.
      Return ONLY the SQL query, nothing else.

      RULES:
      1. Only use columns and tables mentioned in the schema. DONOT assume anything on your own.
      2. Use table aliases for joins
      3. For dates, use CURRENT_DATE for "today" and INTERVAL for ranges
      4. Always include LIMIT 100 unless specified
      5. Use ILIKE for case-insensitive text searches
      6. Return ONLY the SQL query, no explanations

      EXAMPLES:
      User:"Show me users who signed up last week"
      SQL: SELECT * FROM users WHERE created_at >= CURRENT_DATE - INTERVAL '7 days' LIMIT 100;

      User: "Find messages containing 'hello'"
      SQL: SELECT * FROM messages WHERE content ILIKE '%hello%' LIMIT 100;

      User: "How many chats were created this month?"
      SQL: SELECT COUNT(*) FROM chats WHERE created_at >= DATE_TRUNC('month', CURRENT_DATE) LIMIT 1;


      Database Schema:
      #{schema}

      User Question: #{natural_language_query}
    PROMPT

    begin
      response = client.ask(prompt)
      sql_query = response.content.strip

      # Execute the query
      result = ActiveRecord::Base.connection.execute(sql_query)

      {
        success: true,
        sql_query: sql_query,
        results: result.to_a,
        error: nil
      }
    rescue => e
      {
        success: false,
        sql_query: sql_query || nil,
        results: nil,
        error: e.message
      }
    end
  end
end
