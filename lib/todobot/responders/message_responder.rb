require 'todobot/app_configurator'
require 'todobot/responders/base_responder'
require 'todobot/models/message'
require 'todobot/message_sender'
require 'todobot/services/commands/undefined_command_service'
require 'todobot/services/tasks/create_task_service'
require 'todobot/services/lists/create_list_service'
require 'todobot/commands'

module TodoBot
  class MessageResponder < BaseResponder
    include TodoBot::Commands

    def respond
      return unless message.respond_to?(:text) && message.text.present?

      text, options = perform_action
      send_message(text, options)
    end

    private

    def perform_action
      command, text = message.text.gsub(AppConfigurator.settings.bot_name, '').split(/ /, 2)

      service, options = choose_service_and_options(command, text)

      [service.execute, options]
    end

    def send_message(text, options)
      args = default_args.merge!(options).merge!(text: text)

      TodoBot::MessageSender.new(args).send
    end

    def choose_service_and_options(command, text)
      return service_and_options_by_command(command, default_args, text) if defined_command?(command)

      service =
        case chat.status
        when 'create_task'
          TodoBot::Tasks::CreateTaskService.new(default_args.merge!(name: "#{command} #{text}"))
        when 'create_list'
          TodoBot::Lists::CreateListService.new(default_args.merge!(name: "#{command} #{text}"))
        else
          TodoBot::Commands::UndefinedCommandService.new(default_args.merge!(command: command))
        end

      [service, {}]
    end

    def service_and_options_by_command(command, args, text)
      command_key = COMMANDS.keys.find { |key| key.include?(command) }
      command = COMMANDS.fetch(command_key)

      service = command[:class].new(command[:args].call(args, text))
      options = command[:options].call(args, text)

      [service, options]
    end

    def default_args
      {
        bot: bot,
        chat: chat,
        message: message,
        user: user
      }
    end
  end
end
