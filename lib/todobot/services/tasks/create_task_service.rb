require 'todobot/services/base_service'

module TodoBot
  module Tasks
    class CreateTaskService < BaseService
      def execute
        return I18n.t('list.not_exists') unless chat.lists.any?

        if name.present?
          create_task
        else
          set_status
        end
      end

      private

      attr_reader :name

      def post_initialize(args)
        @name = args[:name]
      end

      def create_task
        new_task = chat.current_list.tasks.new(name: name, user: user)

        if new_task.save
          chat.show_list!

          message = TodoBot::CollectionToMessagePresenter.new(chat.tasks_of_current_list).execute

          "#{I18n.t('task.created', task: name)}\n\n#{message}"
        else
          new_task.errors.values.join(',')
        end
      end

      def set_status
        chat.create_task!

        I18n.t('task.create')
      end
    end
  end
end
