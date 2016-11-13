FactoryGirl.define do
  factory :telegram_message, class: Telegram::Bot::Types::Message do
    skip_create

    sequence(:message_id) { |n| n }
    association :from, factory: :telegram_user
    date { DateTime.current.to_i }
    association :chat, factory: :telegram_private_chat
    text '/start'
  end
end
