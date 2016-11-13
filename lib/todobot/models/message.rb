require 'todobot/models/user'
require 'todobot/models/chat'

module TodoBot
  class Message < ActiveRecord::Base
    self.inheritance_column = nil

    belongs_to :user
    belongs_to :chat
  end
end
