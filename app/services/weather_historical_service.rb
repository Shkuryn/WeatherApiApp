# frozen_string_literal: true

class WeatherHistoricalService
  INTERVAL = 24.hours

    def aggregate_temperature(operation)
      raise ArgumentError, 'Invalid operation' unless valid_operation?(operation)

      temperature = Forecast.where('observation_time >= ?', INTERVAL.ago).send(operation, :temperature)
      temperature || raise(ActiveRecord::RecordNotFound, "#{operation.capitalize} temperature not found!")
    end

    private

    def valid_operation?(operation)
      %i[max min average].include?(operation.to_sym)
    end
  end

