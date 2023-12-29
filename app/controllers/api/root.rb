# frozen_string_literal: true

module API
  class Root < Grape::API
    prefix 'api'
    format :json

    mount Weather::WeatherFetcher

    add_swagger_documentation info: { title: 'grape-on-rails' }
  end
end
