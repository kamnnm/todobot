require 'active_record'
require 'todobot/app_configurator'
require 'todobot/wrapper_responder'
require 'todobot/bot_logger'
require 'todobot/environment'

module TodoBot
  class << self
    def run(token)
      logger.info 'Starting todobot'

      Telegram::Bot::Client.run(token) do |bot|
        begin
          bot.listen do |message|
            logger.info "received message from user: @#{message.from.username}"

            begin
              TodoBot::WrapperResponder.new(bot: bot, message: message).respond
            rescue => e
              handle_error(bot, e)
            end
          end
        rescue => e
          handle_error(bot, e)

          sleep 1
          retry
        end
      end
    end

    def env
      @env ||= Environment.new
    end

    def logger
      @logger ||= BotLogger.new
    end

    private

    def handle_error(bot, error)
      logger.error error.message
      return unless AppConfigurator.settings.sadness_chat.present?

      bot.api.send_message(chat_id: AppConfigurator.settings.sadness_chat, text: error.message)
    end
  end
end
