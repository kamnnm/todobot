require 'shared_contexts/shared_bot'

describe 'Create list' do
  include_context 'bot'
  let(:message_id) { 1 }
  let(:message) { build(:telegram_message, text: command) }
  let(:command) { '/create' }

  context 'when user send first message' do
    before do
      stub_request(:post, url).to_return(status: 200,
                                         body: {'ok' => true, 'result' => {'message_id' => message_id}}.to_json,
                                         headers: {content_type: 'application/json'})

      TodoBot::WrapperResponder.new(bot: bot, message: message).respond
    end

    context 'when command contains list name' do
      let(:command) { '/create My super list' }

      it 'returns list.created' do
        expect(WebMock).to have_requested(:post, url)
          .with(body: hash_including(text: I18n.t('list.created', list: 'My super list')))
      end

      it { expect(TodoBot::List.count).to eq 1 }
    end

    context 'when command doesn`t contain list name' do
      it { expect(WebMock).to have_requested(:post, url).with(body: hash_including(text: I18n.t('list.create'))) }
      it { expect(TodoBot::Chat.first.create_list?).to be_truthy }
    end
  end

  context 'when user send name for list' do
    let(:reply_to_message) { build(:telegram_message, text: I18n.t('list.create'), message_id: message_id) }
    let(:new_message_with_list_name) do
      build(:telegram_message, text: 'List name',
                               chat: message.chat,
                               reply_to_message: reply_to_message)
    end

    before do
      stub_request(:post, url).to_return(body: '{}')

      create(:chat, id: message.chat.id, type: message.chat.type)
      TodoBot::WrapperResponder.new(bot: bot, message: message).respond
      TodoBot::WrapperResponder.new(bot: bot, message: new_message_with_list_name).respond
    end

    it 'returns list.created' do
      expect(WebMock).to have_requested(:post, url)
        .with(body: hash_including(text: I18n.t('list.created', list: 'List name')))
    end

    it { expect(TodoBot::List.count).to eq 1 }
  end
end
