FactoryGirl.define do
  factory :task, class: TodoBot::Task do
    list
    user
    sequence(:name) { |n| "Task name #{n}" }
    sequence(:message_id) { |n| n }
  end
end
