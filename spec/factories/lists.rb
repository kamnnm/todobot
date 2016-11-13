FactoryGirl.define do
  factory :list, class: TodoBot::List do
    chat
    user
    sequence(:name) { |n| "List name #{n}" }
  end
end
