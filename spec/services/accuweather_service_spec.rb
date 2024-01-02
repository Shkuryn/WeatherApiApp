require 'rails_helper'

RSpec.describe AccuweatherService do
  describe '#call' do
    context 'when empty data' do
      it 'fetches and saves weather data' do
        VCR.use_cassette('accuweather_service') do
          expect {
            AccuweatherService.call
          }.to change { Forecast.count }.by(24)
        end
      end

      context 'when data exist', :aggregate_failures do
        let!(:forecast1) { FactoryBot.create(:forecast, epoch_time: 1704200280, temperature: 10) }
        let!(:forecast2) { FactoryBot.create(:forecast, epoch_time: 1704146220, temperature: 15) }

        it 'update temperature' do
          expect {
            VCR.use_cassette('accuweather_service') do
              AccuweatherService.call
            end
          }.to change { Forecast.count }.from(2).to(24)

        expect(Forecast.find_by(epoch_time: 1704200280).temperature).to eq(-9.7)
        expect(Forecast.find_by(epoch_time:   ).temperature).to eq(-5.4)
        end
      end
    end
  end
end
