module TodoBot
  class BaseService
    def initialize(args = {})
      @chat = args.fetch(:chat)
      @user = args.fetch(:user)

      post_initialize(args)
    end

    private

    attr_reader :chat, :user

    def post_initialize(args)
    end
  end
end
