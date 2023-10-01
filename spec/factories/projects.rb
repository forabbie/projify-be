FactoryBot.define do
  factory :project do
    title { "MyString" }
    details { "MyString" }
    expected_completion_date { "2023-10-01 18:51:26" }
    workspace { nil }
  end
end
