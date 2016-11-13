FactoryGirl.define do
  factory :message, class: TodoBot::Message do
    user
    list
    sequence(:message_id) { |n| n }
  end
end
