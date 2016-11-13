require 'shared_contexts/shared_bot'

describe 'Show lists' do
  include_context 'bot'
  let(:message) { build(:telegram_message, text: '/lists') }

  before do
    stub_request(:post, url).to_return(body: '{}')
  end

  context 'when lists not exists' do
    it 'returns list.not_exists' do
      TodoBot::WrapperResponder.new(bot: bot, message: message).respond

      expect(WebMock).to have_requested(:post, url)
        .with(body: hash_including(text: I18n.t('list.not_exists')))
    end
  end

  context 'when lists exists' do
    it 'returns all lists' do
      user = create(:user, id: message.from.id)
      chat = create(:chat, id: message.chat.id, type: message.chat.type)
      user.created_lists.create(chat: chat, name: 'Default')

      TodoBot::WrapperResponder.new(bot: bot, message: message).respond

      expect(WebMock).to have_requested(:post, url)
        .with(body: hash_including(text: '/1. Default'))
    end
  end
end
