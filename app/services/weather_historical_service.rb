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

  def last(count_hours, from)
    observations = fetch_observations(count_hours, from)
    observations.empty? ? handle_empty_observations : format_observations(observations)
  end

  private

  def valid_operation?(operation)
    %i[max min avg].include?(operation.to_sym)
  end

  def fetch_observations(count_hours, from)
    Forecast.where('observation_time >= ?', from - count_hours.hours)
            .order(observation_time: :desc)
            .first(count_hours)
            .pluck(:observation_time, :temperature)
  end

  def handle_empty_observations
    raise ActiveRecord::RecordNotFound, 'Temperature not Found'
  end

  def format_observations(observations)
    observations.map do |time, temperature|
      [
        time.strftime('%Y-%m-%d %H:%M'),
        temperature.to_f
      ]
    end
  end
end
