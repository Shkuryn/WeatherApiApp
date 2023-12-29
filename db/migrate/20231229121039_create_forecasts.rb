# frozen_string_literal: true

class CreateForecasts < ActiveRecord::Migration[7.1]
  def change
    create_table :forecasts do |t|
      t.decimal :temperature
      t.timestamp :epoch_time

      t.timestamps
    end
  end
end
