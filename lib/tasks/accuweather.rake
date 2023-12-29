# frozen_string_literal: true

namespace :accuweather do
  task get_24h: :environment do
    AccuweatherService.call
  end
end
