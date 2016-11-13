require 'todobot/services/commands/help_command_service'
require 'todobot/services/commands/start_command_service'
require 'todobot/services/tasks/create_task_service'
require 'todobot/services/lists/create_list_service'
require 'todobot/services/lists/show_list_service'
require 'todobot/services/lists/show_lists_service'

module TodoBot
  module Commands
    COMMANDS = {
      ['/start'] => {
        class: TodoBot::Commands::StartCommandService,
        args: ->(args, text) { args },
        options: ->(args, text) { {} }
      },

      ['/help'] => {
        class: TodoBot::Commands::HelpCommandService,
        args: ->(args, text) { args },
        options: ->(args, text) { {} }
      },

      ['/create', '/newlist'] => {
        class: TodoBot::Lists::CreateListService,
        args: ->(args, text) { args.merge!(name: text) },
        options: ->(args, text) { {force_reply: text.nil? && args.fetch(:chat).type != 'private'} }
      },

      ['/todo', '/task', '/t'] => {
        class: TodoBot::Tasks::CreateTaskService,
        args: ->(args, text) { args.merge!(name: text) },
        options: ->(args, text) { {force_reply: text.nil? && args.fetch(:chat).type != 'private'} }
      },

      ['/list', '/l'] => {
        class: TodoBot::Lists::ShowListService,
        args: ->(args, text) { args },
        options: ->(args, text) { {} }
      },

      ['/lists', '/ls'] => {
        class: TodoBot::Lists::ShowListsService,
        args: ->(args, text) { args },
        options: ->(args, text) { {} }
      }
    }.freeze
    private_constant :COMMANDS

    private

    def defined_command?(command)
      COMMANDS.keys.any? { |key| key.include?(command) }
    end
  end
end
