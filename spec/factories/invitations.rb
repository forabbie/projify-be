FactoryBot.define do
  factory :invitation do
    sender { nil }
    recipient_email { "MyString" }
    token { "MyString" }
    accepted { false }
    workspace { nil }
  end
end
