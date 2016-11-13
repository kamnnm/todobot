shared_context 'bot', bot: true do
  let(:token) { '123:aaaaa' }
  let(:url) { "https://api.telegram.org/bot#{token}/sendMessage" }
  let(:bot) { Telegram::Bot::Client.new(token) }
end
