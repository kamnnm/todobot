require 'todobot/settings'

module TodoBot
  class AppConfigurator
    class << self
      attr_reader :settings

      def configure
        load_settings
        setup_i18n
        setup_database
      end

      private

      def setup_i18n
        I18n.load_path = Dir["config/locales/#{settings.locale}.yml"]
        I18n.backend.load_translations
        I18n.default_locale = settings.locale.to_sym
      end

      def setup_database
        configuration = YAML.load(IO.read('config/database.yml'))[TodoBot.env.current]

        ActiveRecord::Base.logger = TodoBot.logger
        ActiveRecord::Base.establish_connection(configuration)
      end

      def load_settings
        @settings = Settings.new(YAML.load(IO.read('config/settings.yml')).symbolize_keys)
      end
    end
  end
end
