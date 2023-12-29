
  class Weather < Grape::API
    prefix 'weather'
    format :json

    get :hello do
      { text: 'Hello from weather' }
    end
  end
