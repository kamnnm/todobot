module TodoBot
  class Environment
    def initialize
      set_environment
    end

    %w(development production test).each do |env|
      define_method("#{env}?") do
        environment == env
      end
    end

    def current
      environment
    end

    private

    attr_reader :environment

    def set_environment
      @environment = ENV['BOT_ENV'] || 'development'
    end
  end
end
