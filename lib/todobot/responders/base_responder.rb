require 'todobot/models/user'
require 'todobot/models/chat'

module TodoBot
  class BaseResponder
    def initialize(args)
      @bot = args.fetch(:bot)
      @message = args.fetch(:message)

      set_user
      set_chat
    end

    private

    attr_reader :bot, :message, :user, :chat

    def set_user
      @user = TodoBot::User.find_or_create_by(id: message.from.id)
    end

    def set_chat
      return unless message.respond_to? :chat

      @chat = TodoBot::Chat.find_or_create_by(id: message.chat.id, type: message.chat.type)
    end
  end
end
