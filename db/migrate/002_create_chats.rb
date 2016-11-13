class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.integer :status
      t.string :type, null: false

      t.timestamps null: false
    end
  end
end
