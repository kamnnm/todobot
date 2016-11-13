require 'todobot/responders/base_responder'
require 'todobot/message_sender'

module TodoBot
  class UndefinedResponder < BaseResponder
    def respond
      TodoBot::MessageSender.new(bot: bot, chat: chat, text: I18n.t('undefined_command_type')).send
    end
  end
end
