require 'faker'

FactoryGirl.define do

  factory :page do
    url { Faker::Internet.url }
  end

  factory :change do
    find_text { Faker::Lorem.words(2)}
    replace_text { Faker::Lorem.words(2)}
  end

  factory :user do
    email { Faker::Internet.email }
    password "123zzz"
    password_confirmation { "123zzz" }

    factory :users_with_pages do
      after(:create) do |user|
        FactoryGirl.create_list(:page, rand(5..10), user: user)
      end
    end

   factory :users_with_changes do
      after(:create) do |user|
        FactoryGirl.create_list(:change, rand(5..10), user: user)
      end
    end
  end

end