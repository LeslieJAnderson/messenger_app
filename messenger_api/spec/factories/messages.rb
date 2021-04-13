FactoryBot.define do
  factory :message do
    from_user_id { }
    to_user_id { }
    content { 'Default factory message' }
  end
end
