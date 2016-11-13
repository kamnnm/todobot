require 'shared_contexts/shared_bot'

describe 'Show list' do
  include_context 'bot'
  let(:message) { build(:telegram_message, text: '/list') }

  before do
    stub_request(:post, url).to_return(body: '{}')
  end

  context 'when list not exists' do
    it 'returns list.not_exists' do
      TodoBot::WrapperResponder.new(bot: bot, message: message).respond

      expect(WebMock).to have_requested(:post, url)
        .with(body: hash_including(text: I18n.t('list.not_exists')))
    end
  end

  context 'when list exists' do
    let(:user) { create(:user, id: message.from.id) }
    let(:chat) { create(:chat, id: message.chat.id, type: message.chat.type) }

    context 'when list has no one tasks' do
      before do
        user.created_lists.create(chat: chat, name: 'Default')

        TodoBot::WrapperResponder.new(bot: bot, message: message).respond
      end

      it 'returns task.not_exists' do
        expect(WebMock).to have_requested(:post, url)
          .with(body: hash_including(text: I18n.t('task.not_exists')))
      end

      it { expect(chat.reload.show_list?).to be_falsey }
    end

    context 'when list has tasks' do
      before do
        list = user.created_lists.create(chat: chat, name: 'Default')

        list.tasks.create(name: '1', user: user)
        list.tasks.create(name: '2', user: user)
        list.tasks.create(name: '3', user: user, completed: true)

        TodoBot::WrapperResponder.new(bot: bot, message: message).respond
      end

      it 'returns tasks' do
        expect(WebMock).to have_requested(:post, url)
          .with(body: hash_including(text: "Default\n\n/1. 1\n/2. 2"))
      end

      it { expect(chat.reload.show_list?).to be_truthy }
    end
  end
end
