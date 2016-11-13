require 'todobot/models/chat'
require 'todobot/models/user'
require 'todobot/models/task'
require 'todobot/models/message'

module TodoBot
  class List < ActiveRecord::Base
    LIST_NAME_MAX_LENGTH = 32
    LISTS_NAMES_MAX_LENGTH = 512
    private_constant :LIST_NAME_MAX_LENGTH, :LISTS_NAMES_MAX_LENGTH

    belongs_to :chat
    belongs_to :user

    has_many :tasks

    validates :name, length: {maximum: LIST_NAME_MAX_LENGTH}
    validate :lists_names_length_must_have_not_too_long

    scope :ordered, -> { order(:created_at) }

    private

    def lists_names_length_must_have_not_too_long
      return if chat.lists.pluck(:name).join.length < LISTS_NAMES_MAX_LENGTH

      errors[:base] << I18n.t('activerecord.errors.models.todo_bot/list.too_long', count: LISTS_NAMES_MAX_LENGTH)
    end
  end
end
