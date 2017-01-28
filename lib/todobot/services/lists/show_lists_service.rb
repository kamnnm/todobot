require 'todobot/services/base_service'
require 'todobot/presenters/collection_to_message_presenter'

module TodoBot
  module Lists
    class ShowListsService < BaseService
      def execute
        return I18n.t('list.not_exists') unless chat.lists.any?

        chat.show_lists!

        TodoBot::CollectionToMessagePresenter.new(chat.lists.ordered).execute
      end
    end
  end
end
