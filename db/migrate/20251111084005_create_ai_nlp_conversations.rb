class CreateAiNlpConversations < ActiveRecord::Migration[8.0]
  def change
    create_table :ai_nlp_conversations do |t|
      t.references :user, null: false, foreign_key: true
      t.text :query, null: false
      t.text :sql_query
      t.text :response
      t.text :error

      t.timestamps
    end

    add_index :ai_nlp_conversations, :created_at
    add_index :ai_nlp_conversations, [:user_id, :created_at]
  end
end
