FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    email { Faker::Internet.email }

    # Ensure the auth_token is generated on creation
    after(:build) { |user| user.auth_token ||= SecureRandom.hex }
  end
end
  