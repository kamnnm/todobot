require 'todobot/services/base_service'

module TodoBot
  module Commands
    class StartCommandService < BaseService
      def execute
        I18n.t('greeting_message').concat("\n\n#{I18n.t('help_message')}")
      end
    end
  end
end
