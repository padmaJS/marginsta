class CreateChatSummaries < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_summaries do |t|
      t.references :chat, null: false, foreign_key: true
      t.text :content, null: false
      t.integer :message_count, default: 0
      t.string :summary_type, default: "last_20_messages"

      t.timestamps
    end

    add_index :chat_summaries, [:chat_id, :summary_type]
  end
end
