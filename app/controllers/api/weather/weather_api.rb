
  class Weather < Grape::API
    format :json

    get :hello do
      { text: 'Hello from weather' }
    end
  end
