# frozen_string_literal: true

class AccuweatherService
  BASE_URL = 'https://dataservice.accuweather.com'
  API_KEY = ENV.fetch('ACCUWEATHER_API_KEY')
  LOCATION_KEY = ENV.fetch('LOCATION_KEY', '28580') # Minsk

  def self.call
    new.call
  end

  def initialize
    @dalli_client = Dalli::Client.new('localhost:11211')
  end

  # rubocop:disable Metrics/AbcSize
  def call
    response.each do |weather|
      epoch_time = (Time.at(weather['EpochTime']).beginning_of_hour + 1.hour).to_i
      observation_time = Time.parse(weather['LocalObservationDateTime']).to_datetime.beginning_of_hour + 1.hour
      temperature = weather.dig('Temperature', 'Metric', 'Value')
      Forecast
        .find_or_initialize_by(epoch_time:)
        .update!(temperature:, observation_time:)
    end
    clear_cache
  end
  # rubocop:enable Metrics/AbcSize

  private

  def clear_cache
    keys_to_delete = %w[current historical min max avg]
    keys_to_delete.each { |k| @dalli_client.delete(k) }
  end

  def api_url
    "#{BASE_URL}/currentconditions/v1/#{LOCATION_KEY}/historical/24"
  end

  def response
    @response ||= HTTParty.get(api_url, query: { apikey: API_KEY }).parsed_response
  end
end
