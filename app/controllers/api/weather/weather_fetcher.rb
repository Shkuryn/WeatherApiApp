# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
module API
  module Weather
    class WeatherFetcher < Grape::API
      helpers do
        def dalli_client
          @dalli_client ||= Dalli::Client.new('localhost:11211')
        end
      end
      namespace 'weather' do
        desc 'Returns current temperature.'
        get :current do
          dalli_client.fetch('current') { WeatherHistoricalService.new.last(1, Time.current) }
        end

        desc 'find closest temperature by passed timestamp'
        params do
          requires :timestamp, type: Integer, desc: 'Timestamp to find temperature'
        end

        get 'by_time' do
          timestamp = Time.at(params[:timestamp]).beginning_of_hour
          dalli_client.fetch("by_time#{timestamp}") do
            { 'temperature': WeatherHistoricalService.new.last(1, timestamp) }
          rescue ActiveRecord::RecordNotFound
            @dalli_client.delete("by_time#{timestamp}")
            error!('Temperature not found', 404)
          end
        end

        namespace 'historical' do
          get do
            dalli_client.fetch('historical') { WeatherHistoricalService.new.last(24, Time.current) }
          end
          get :min do
            dalli_client.fetch('min') { { 'min': WeatherHistoricalService.new.aggregate_temperature(:min) } }
          end
          get :max do
            dalli_client.fetch('max') { { 'max': WeatherHistoricalService.new.aggregate_temperature(:max) } }
          end
          get :avg do
            dalli_client.fetch('avg') { { 'average': WeatherHistoricalService.new.aggregate_temperature(:avg) } }
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
