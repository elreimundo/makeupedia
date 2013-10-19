require 'faker'

FactoryGirl.define do

  factory :page do
    url { Faker::Internet.url }
  end

  factory :user do
    email { Faker::Internet.email }

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