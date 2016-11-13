require 'todobot/services/base_service'

module TodoBot
  module Lists
    class CreateListService < BaseService
      def execute
        if name.present?
          create_list
        else
          set_status
        end
      end

      private

      attr_reader :name

      def post_initialize(args)
        @name = args[:name]
      end

      def create_list
        new_list = user.created_lists.new(chat: chat, name: name)

        if new_list.save
          chat.update_attribute(:list_id, new_list.id)

          I18n.t('list.created', list: name)
        else
          new_list.errors.values.join(',')
        end
      end

      def set_status
        chat.create_list!

        I18n.t('list.create')
      end
    end
  end
end
