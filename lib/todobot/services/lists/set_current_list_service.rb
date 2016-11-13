require 'todobot/services/base_service'
require 'todobot/services/lists/show_list_service'

module TodoBot
  module Lists
    class SetCurrentListService < BaseService
      def execute
        lists = chat.lists.ordered

        if number.between?(1, lists.size)
          set_current_list(lists[number - 1])
        else
          I18n.t('list.not_found')
        end
      end

      private

      attr_reader :number, :args

      def post_initialize(args)
        @number = args.delete(:number)
        @args = args
      end

      def set_current_list(list)
        chat.update_attribute(:list_id, list.id)

        ShowListService.new(args).execute
      end
    end
  end
end
