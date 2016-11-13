require 'todobot/services/base_service'
require 'todobot/presenters/collection_to_message_presenter'

module TodoBot
  module Lists
    class ShowListService < BaseService
      def execute
        return I18n.t('list.not_exists') unless chat.lists.any?
        return I18n.t('task.not_exists') unless (tasks = chat.tasks_of_current_list).any?

        chat.show_list!

        message = TodoBot::CollectionToMessagePresenter.new(tasks).execute

        "#{chat.current_list.name}\n\n#{message}"
      end
    end
  end
end
