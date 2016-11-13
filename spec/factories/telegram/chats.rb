FactoryGirl.define do
  factory :telegram_chat, class: Telegram::Bot::Types::Chat do
    skip_create

    sequence(:id) { |n| n }
    sequence(:first_name) { |n| "chat_first_name_#{n}" }
    sequence(:last_name) { |n| "chat_last_name_#{n}" }
    sequence(:username) { |n| "chat_username_#{n}" }
    title ''

    trait :private do
      type 'private'
    end

    trait :group do
      type 'group'
    end

    trait :supergroup do
      type 'supergroup'
    end

    trait :channel do
      type 'channel'
    end

    factory :telegram_private_chat, traits: [:private]
    factory :telegram_group_chat, traits: [:group]
    factory :telegram_supergroup_chat, traits: [:supergroup]
    factory :telegram_channel_chat, traits: [:channel]
  end
end
