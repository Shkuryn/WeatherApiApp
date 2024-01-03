require 'rails_helper'

RSpec.describe API::Weather::WeatherFetcher, type: :request do
  describe 'GET /weather/current' do
    let!(:forecast) do
      FactoryBot.create(:forecast,
                        observation_time: (Time.current).beginning_of_hour,
                        temperature: 10)
    end
    it 'returns the current temperature' do
      get '/api/weather/current'

      expect(response.status).to eq(200)
      body = JSON.parse(response.body)
      expect(body).to include(["2024-01-03 17:00", 10.0])
    end
  end

  describe 'GET /weather/by_time' do
    let!(:forecast) { FactoryBot.create(:forecast, observation_time: Time.current - 1.hour, temperature: 15) }

    it 'finds the closest temperature by timestamp' do
      timestamp = Time.current.to_i

      get "/api/weather/by_time?timestamp=#{timestamp}"

      expect(response.status).to eq(200)
      body = JSON.parse(response.body)
      expect(body).to have_key('temperature')
      expect(body['temperature']).to eq("15.0")
    end

    it 'returns 404 if temperature not found for timestamp' do
      timestamp = Time.current.to_i - 55000

      get "/api/weather/by_time?timestamp=#{timestamp}"

      expect(response.status).to eq(404)
      body = JSON.parse(response.body)
      expect(body['error']).to eq('Temperature not found')
    end
  end

  describe 'GET /weather/historical' do
    before do
      FactoryBot.create_list(:forecast, 24) do |forecast, index|
        forecast.observation_time = (24.hours - (index + 1).hours).ago.beginning_of_hour
        forecast.save!
      end
    end

    after { Forecast.destroy_all}

    it 'returns historical temperatures for the last 24 hours', :aggregate_failures do
      get '/api/weather/historical'

      expect(response.status).to eq(200)
      body = JSON.parse(response.body)
      expect(body).to be_an_instance_of(Array)
      expect(body.size).to eq(24)
    end
  end

  describe 'GET /weather/historical/min' do
    let!(:forecast) do
      FactoryBot.create(:forecast,
                        observation_time: (Time.current).beginning_of_hour,
                        temperature: 10)
    end
    it 'returns the minimum temperature of historical data' do
      get '/api/weather/historical/min'

      expect(response.status).to eq(200)
      body = JSON.parse(response.body)
      expect(body).to have_key('min')
    end
  end

  describe 'GET /weather/historical/max' do
    let!(:forecast) do
      FactoryBot.create(:forecast,
                        observation_time: (Time.current).beginning_of_hour,
                        temperature: 10)
    end
    it 'returns the minimum temperature of historical data' do
      get '/api/weather/historical/max'

      expect(response.status).to eq(200)
      body = JSON.parse(response.body)
      expect(body).to have_key('max')
    end
  end

  describe 'GET /weather/historical/max' do
    let!(:forecast) do
      FactoryBot.create(:forecast,
                        observation_time: (Time.current).beginning_of_hour,
                        temperature: 10)
    end
    it 'returns the minimum temperature of historical data' do
      get '/api/weather/historical/avg'

      expect(response.status).to eq(200)
      body = JSON.parse(response.body)
      expect(body).to have_key('average')
    end
  end
end
