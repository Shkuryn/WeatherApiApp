module API
  module Weather
    class WeatherFetcher < Grape::API
      namespace 'weather' do

        desc 'Returns current temperature.'
        get :current do
          { now: -10.7 }
          # Rails.cache.read('1703955420')
        end
        namespace 'historical' do

          get do
            { '00:00': '-10.7',
              '01:00': '-10.7',
              '02:00': '-10.8' }
          end
          get :min do
            { 'min': WeatherHistoricalService.new.aggregate_temperature(:min) }
          end
          get :max do
            { 'max': WeatherHistoricalService.new.aggregate_temperature(:max) }
          end
          get :avg do
            { 'average': WeatherHistoricalService.new.aggregate_temperature(:average) }
          end
        end
      end
    end
  end
end