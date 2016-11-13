class AddListReferenceToChat < ActiveRecord::Migration
  def change
    add_reference :chats, :list, index: true
    add_foreign_key :chats, :lists
  end
end
