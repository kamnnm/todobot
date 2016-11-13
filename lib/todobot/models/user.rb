require 'todobot/models/chat'
require 'todobot/models/list'
require 'todobot/models/message'

module TodoBot
  class User < ActiveRecord::Base
    has_many :created_lists, class_name: List
    has_many :messages
  end
end
