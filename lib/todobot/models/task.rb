require 'todobot/models/list'
require 'todobot/models/user'

module TodoBot
  class Task < ActiveRecord::Base
    TASK_NAME_MAX_LENGTH = 512
    TASKS_NAMES_MAX_LENGTH = 2048
    private_constant :TASK_NAME_MAX_LENGTH, :TASKS_NAMES_MAX_LENGTH

    belongs_to :list
    belongs_to :user

    validates :name, length: {maximum: TASK_NAME_MAX_LENGTH}
    validate :tasks_names_length_must_have_not_too_long

    scope :ordered, -> { order(:created_at) }
    scope :completed, -> { where(completed: true) }
    scope :uncompleted, -> { where(completed: false) }
    scope :completed_ordered, -> { completed.ordered }
    scope :uncompleted_ordered, -> { uncompleted.ordered }

    private

    def tasks_names_length_must_have_not_too_long
      return if list.tasks.pluck(:name).join.length < TASKS_NAMES_MAX_LENGTH

      errors[:base] << I18n.t('activerecord.errors.models.todo_bot/task.too_long', count: TASKS_NAMES_MAX_LENGTH)
    end
  end
end
