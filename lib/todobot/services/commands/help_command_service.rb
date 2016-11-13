require 'todobot/services/base_service'

module TodoBot
  module Commands
    class HelpCommandService < BaseService
      def execute
        I18n.t('help_message')
      end
    end
  end
end
