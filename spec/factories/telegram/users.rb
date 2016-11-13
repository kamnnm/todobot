FactoryGirl.define do
  factory :telegram_user, class: Telegram::Bot::Types::User do
    skip_create

    sequence(:id) { |n| n }
    sequence(:first_name) { |n| "user_first_name_#{n}" }
    sequence(:last_name) { |n| "user_last_name_#{n}" }
    sequence(:username) { |n| "user_username_#{n}" }
  end
end
