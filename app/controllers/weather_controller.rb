# frozen_string_literal: true

class WeatherController < ApplicationController
  def health
    render plain: 'OK'
  end
end
