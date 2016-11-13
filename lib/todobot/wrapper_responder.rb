require 'todobot/responders/message_responder'
require 'todobot/responders/undefined_responder'

module TodoBot
  class WrapperResponder
    def initialize(args)
      @bot = args.fetch(:bot)
      @message = args.fetch(:message)
    end

    def respond
      responder.new(bot: bot, message: message).respond
    end

    private

    attr_reader :message, :bot

    def responder
      case message
      when Telegram::Bot::Types::Message
        MessageResponder
      else
        UndefinedResponder
      end
    end
  end
end
