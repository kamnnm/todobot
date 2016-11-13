require 'logger'

module TodoBot
  class BotLogger < Logger
    def initialize
      output =
        if TodoBot.env.production?
          AppConfigurator.settings.production_log_path
        elsif TodoBot.env.development? && AppConfigurator.settings.development_log_path.present?
          AppConfigurator.settings.development_log_path
        else
          STDOUT
        end

      super(output)
    end
  end
end
