module API
  module Weather
    class WeatherFetcher < Grape::API
      namespace 'weather' do

        desc 'Returns current temperature.'
        get :current do
          { now: -10.7 }
        end
        namespace 'historical' do

          get do
            { '00:00': '-10.7',
              '01:00': '-10.7',
              '02:00': '-10.8' }
          end
          get :min do
            { 'min': '-100' }
          end
          get :max do
            { 'max': '100' }
          end
        end
      end
    end
  end
end