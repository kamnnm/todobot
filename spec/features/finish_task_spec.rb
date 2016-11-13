require 'shared_contexts/shared_bot'

describe 'Finish task' do
  include_context 'bot'

  before do
    stub_request(:post, url).to_return(body: '{}')

    message = build(:telegram_message, text: '/list')
    telegram_chat = message.chat

    user = create(:user, id: message.from.id)
    chat = create(:chat, id: telegram_chat.id, type: telegram_chat.type)
    list = user.created_lists.create(chat: chat, name: 'Default')
    list.tasks.create(name: '1', user: user)
    list.tasks.create(name: '2', user: user)
    list.tasks.create(name: '3', user: user)

    TodoBot::WrapperResponder.new(bot: bot, message: message).respond

    message = build(:telegram_message, chat: telegram_chat, text: '/2')

    TodoBot::WrapperResponder.new(bot: bot, message: message).respond
  end

  it 'returns task.finished' do
    expect(WebMock).to have_requested(:post, url)
      .with(body: hash_including(text: "#{I18n.t('task.finished', task: '2')}\n\n/1. 1\n/2. 3"))
  end

  it { expect(TodoBot::List.first.tasks.uncompleted.count).to eq 2 }
  it { expect(TodoBot::List.first.tasks.completed.count).to eq 1 }
end
