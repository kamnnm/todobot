require 'todobot/models/list'
require 'todobot/models/user'

module TodoBot
  class Chat < ActiveRecord::Base
    self.inheritance_column = nil

    has_many :lists
    belongs_to :list

    enum status: [:create_task, :create_list, :show_list, :show_lists]

    def current_list
      list || lists.last
    end

    def tasks_of_current_list
      current_list.tasks.uncompleted_ordered
    end
  end
end
