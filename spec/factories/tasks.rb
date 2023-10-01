FactoryBot.define do
  factory :task do
    title { "MyString" }
    description { "MyString" }
    deadline { "MyString" }
    notes { "MyString" }
    owner { 1 }
    task_priority { nil }
    task_status { nil }
  end
end
