module API
  module Weather
    class WeatherFetcher < Grape::API
      namespace 'weather' do

        desc 'Returns current temperature.'
        get :current do
          WeatherHistoricalService.new.last(1)
        end

        desc 'find closest temperature by passed timestamp'
        params do
          requires :timestamp, type: Integer, desc: 'Timestamp to find temperature'
        end
        get 'by_time' do
          timestamp = Time.at(params[:timestamp])

          closest_temperature = Forecast.where('observation_time <= ?', timestamp).order(observation_time: :desc).first
          error!('Temperature not found', 404) unless closest_temperature

          { temperature: closest_temperature.temperature }
        end

        namespace 'historical' do

          get do
           WeatherHistoricalService.new.last(24)
          end
          get :min do
            { 'min': WeatherHistoricalService.new.aggregate_temperature(:min) }
          end
          get :max do
            { 'max': WeatherHistoricalService.new.aggregate_temperature(:max) }
          end
          get :avg do
            { 'average': WeatherHistoricalService.new.aggregate_temperature(:avg) }
          end
        end
      end
    end
  end
end