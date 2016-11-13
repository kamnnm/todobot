require 'shared_contexts/shared_bot'

describe 'Create task' do
  include_context 'bot'
  let(:message) { build(:telegram_message, text: command) }
  let(:user) { create(:user, id: message.from.id) }
  let(:chat) { create(:chat, id: message.chat.id, type: message.chat.type) }
  let(:command) { '/task' }

  before { stub_request(:post, url).to_return(body: '{}') }

  context 'when list not exists' do
    it 'returns list.not_exists' do
      TodoBot::WrapperResponder.new(bot: bot, message: message).respond

      expect(WebMock).to have_requested(:post, url)
        .with(body: hash_including(text: I18n.t('list.not_exists')))
    end
  end

  context 'when list exists' do
    context 'when user first message' do
      context 'when command contains task name' do
        let(:command) { '/task Do something' }

        before do
          user.created_lists.create(chat: chat, name: 'Default')

          TodoBot::WrapperResponder.new(bot: bot, message: message).respond
        end

        it 'returns task.created' do
          expect(WebMock).to have_requested(:post, url)
            .with(body: hash_including(text: "#{I18n.t('task.created', task: 'Do something')}\n\n/1. Do something"))
        end

        it { expect(chat.reload.show_list?).to be_truthy }
      end

      context 'when command doesn`t contain task name' do
        before do
          user.created_lists.create(chat: chat, name: 'Default')

          TodoBot::WrapperResponder.new(bot: bot, message: message).respond
        end

        it 'returns task.create' do
          expect(WebMock).to have_requested(:post, url)
            .with(body: hash_including(text: I18n.t('task.create')))
        end

        it { expect(chat.reload.create_task?).to be_truthy }
      end
    end

    context 'when user send name for task' do
      let(:reply_to_message) do
        build(:telegram_message, text: I18n.t('task.create'), message_id: message.message_id)
      end
      let(:message_with_task_name) do
        build(:telegram_message, chat: message.chat,
                                 text: 'Task name',
                                 reply_to_message: reply_to_message)
      end
      let!(:list) { user.created_lists.create(chat: chat, name: 'Default') }

      before do
        TodoBot::WrapperResponder.new(bot: bot, message: message).respond
        TodoBot::WrapperResponder.new(bot: bot, message: message_with_task_name).respond
      end

      it 'returns task.created' do
        expect(WebMock).to have_requested(:post, url)
          .with(body: hash_including(text: "#{I18n.t('task.created', task: 'Task name')}\n\n/1. Task name"))
      end

      it { expect(list.tasks.size).to eq 1 }
      it { expect(chat.reload.show_list?).to be_truthy }
    end
  end
end
