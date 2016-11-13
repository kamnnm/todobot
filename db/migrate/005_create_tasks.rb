class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :list, index: true, null: false
      t.references :user, index: true, null: false
      t.string :name, null: false
      t.boolean :completed, null: false, default: false

      t.timestamps null: false
    end

    add_foreign_key :tasks, :lists
    add_foreign_key :tasks, :users
  end
end
