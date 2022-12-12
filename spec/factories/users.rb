require 'faker'

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email.downcase }
    password { Faker::Alphanumeric.alphanumeric(number: 10) }
  end
end 