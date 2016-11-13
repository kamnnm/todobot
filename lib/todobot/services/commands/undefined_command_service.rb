require 'todobot/services/base_service'
require 'todobot/services/tasks/finish_task_service'
require 'todobot/services/lists/set_current_list_service'

module TodoBot
  module Commands
    class UndefinedCommandService < BaseService
      def execute
        return service.execute if service.present?

        I18n.t('undefined_message')
      end

      private

      attr_reader :command, :args

      def post_initialize(args)
        @command = args.delete(:command)
        @args = args
      end

      def service
        return @service if defined? @service

        @service =
          case
          when chat.show_list? && command =~ %r{\A\/\d+\z}
            TodoBot::Tasks::FinishTaskService.new(chat: chat, user: user, number: number)
          when chat.show_lists? && command =~ %r{\A\/\d+\z}
            TodoBot::Lists::SetCurrentListService.new(args.merge!(number: number))
          end
      end

      def number
        command.remove('/').to_i
      end
    end
  end
end
