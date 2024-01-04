# frozen_string_literal: true

FactoryBot.define do
  factory :forecast do
    epoch_time { Faker::Number.number(digits: 10) }
    observation_time { Faker::Time.backward(days: 14) }
    temperature { Faker::Number.decimal(l_digits: 2) }
  end
end
