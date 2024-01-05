# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccuweatherService do
  describe '#call' do
    context 'when empty data' do
      it 'fetches and saves weather data' do
        VCR.use_cassette('accuweather_service') do
          expect do
            AccuweatherService.call
          end.to change { Forecast.count }.by(24)
        end
      end
    end
    context 'when data exist', :aggregate_failures do
      let(:epochtime1) { (Time.current.beginning_of_hour - 1.hour).to_i }
      let(:epochtime2) { (Time.current.beginning_of_hour - 2.hour).to_i }
      let!(:forecast1) { FactoryBot.create(:forecast, epoch_time: epochtime1, temperature: 10) }
      let!(:forecast2) { FactoryBot.create(:forecast, epoch_time: epochtime2, temperature: 15) }

      it 'update temperature' do
        expect do
          VCR.use_cassette('accuweather_service') do
            AccuweatherService.call
          end
        end.to change { Forecast.count }.from(2).to(24)
      end
    end
  end
end
