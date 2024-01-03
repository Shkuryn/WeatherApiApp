class WeatherController < ApplicationController
  def health
    render plain: 'OK'
  end
end
