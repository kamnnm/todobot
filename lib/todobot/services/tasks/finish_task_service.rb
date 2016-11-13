require 'todobot/services/base_service'
require 'todobot/presenters/collection_to_message_presenter'

module TodoBot
  module Tasks
    class FinishTaskService < BaseService
      def execute
        return I18n.t('list.not_exists') unless chat.current_list

        tasks = chat.tasks_of_current_list
        if number.between?(1, tasks.size)
          finish_task(tasks)
        else
          I18n.t('task.not_found')
        end
      end

      private

      attr_reader :number

      def post_initialize(args)
        @number = args.fetch(:number)
      end

      def finish_task(tasks)
        task = tasks[number - 1]
        task.update_attribute(:completed, true)

        message = TodoBot::CollectionToMessagePresenter.new(tasks.reload).execute

        "#{I18n.t('task.finished', task: task.name)}\n\n#{message}"
      end
    end
  end
end
