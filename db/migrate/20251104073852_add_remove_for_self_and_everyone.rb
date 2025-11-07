class AddRemoveForSelfAndEveryone < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :removed_for_self, :boolean, default: false
    add_column :messages, :removed_for_everyone, :boolean, default: false
    add_column :messages, :removed_for_user_ids, :integer, array: true, default: []
  end
end
