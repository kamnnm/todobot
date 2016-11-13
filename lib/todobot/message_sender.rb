module TodoBot
  class MessageSender
    def initialize(args = {})
      @bot = args.delete(:bot)
      @text = args.delete(:text)
      @chat = args.delete(:chat)
      @message = args.delete(:message)
      @force_reply = args[:force_reply] == true ? true : false
    end

    def send
      TodoBot.logger.info "sending '#{text}' to #{message.chat.username}"

      args = {chat_id: message.chat.id, text: text}
      args = set_force_reply(args)

      bot.api.send_message(args)
    end

    private

    attr_reader :bot, :text, :chat, :message, :force_reply

    def set_force_reply(args)
      if force_reply
        args[:reply_markup] = Telegram::Bot::Types::ForceReply.new(force_reply: force_reply, selective: true)
        args[:reply_to_message_id] = message.message_id
      end

      args
    end
  end
end
