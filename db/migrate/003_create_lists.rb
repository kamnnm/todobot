class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.references :chat, index: true, null: false
      t.references :user, index: true, null: false
      t.string :name, null: false
      t.timestamps null: false
    end

    add_foreign_key :lists, :chats
    add_foreign_key :lists, :users
  end
end
