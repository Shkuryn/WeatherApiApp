# frozen_string_literal: true

class WeatherHistoricalService
  INTERVAL = 24.hours

  def aggregate_temperature(operation)
    raise ArgumentError, 'Invalid operation' unless valid_operation?(operation)

    temperature = Forecast.where('observation_time >= ?', INTERVAL.ago).pluck(:temperature).send(operation)
    if temperature.nil? || temperature.nan?
      raise(ActiveRecord::RecordNotFound,
            "#{operation.capitalize} temperature not found!")
    end

    temperature
  end

  def last(count_hours)
    observations = Forecast.where('observation_time >= ?', count_hours.hours.ago).pluck(:observation_time, :temperature)
    observations.map do |time, temperature|
      [
        time.strftime('%Y-%m-%d %H:%M'),
        temperature.to_f
      ]
    end
  end

  private

  def valid_operation?(operation)
    %i[max min avg].include?(operation.to_sym)
  end
end
