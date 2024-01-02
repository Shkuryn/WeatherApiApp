# frozen_string_literal: true

class WeatherResponder
  def self.current_temperature
    cached_data = Rails.cache.read('current_temperature')

    if cached_data.present?
      JSON.parse(cached_data) # Возвращаем данные из кэша в формате JSON
    else
      temperature = fetch_current_temperature # Получаем данные из базы данных или другого источника
      Rails.cache.write('current_temperature', { now: temperature }.to_json)
      { now: temperature }
    end
  end

  def self.fetch_current_temperature
    # Логика запроса текущей температуры из базы данных или другого источника
    # Если данные не найдены, можно выбросить исключение или вернуть nil
    # Например:
    # temperature = DatabaseModel.current_temperature
    # return temperature if temperature.present?
    # raise StandardError, 'Температура не найдена'
  end
end
