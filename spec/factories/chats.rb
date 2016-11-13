FactoryGirl.define do
  factory :chat, class: TodoBot::Chat do
    sequence(:id) { |n| n }
    sequence(:type) { '' }

    trait :with_list do
      transient do
        lists_count 1
      end

      after(:create) do |chat, evaluator|
        create_list :list, evaluator.lists_count, chat: chat
      end
    end
  end
end
