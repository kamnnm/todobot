module TodoBot
  class Settings
    attr_reader :bot_name,
                :sadness_chat,
                :locale,
                :production_log_path,
                :development_log_path,
                :token

    def initialize(args)
      @bot_name = args.fetch(:bot_name)
      @sadness_chat = args[:sadness_chat]
      @locale = args.fetch(:locale, 'en')
      @production_log_path = args.fetch(:production_log_path, 'log/production.log')
      @development_log_path = args[:development_log_path]
      @token = args.fetch(:token)
    end
  end
end
