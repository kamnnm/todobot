class ChangeChatsAndUsersColumnsTypes < ActiveRecord::Migration
  def change
    change_column :lists, :user_id, :bigint
    change_column :lists, :chat_id, :bigint
    change_column :tasks, :user_id, :bigint
    change_column :chats, :id, :bigint
    change_column :users, :id, :bigint
  end
end
