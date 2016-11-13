FactoryGirl.define do
  factory :user, class: TodoBot::User do
    sequence(:id) { |n| n }
  end
end
