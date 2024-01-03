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
    end
    context 'when data exist', :aggregate_failures do
      let(:epoch_time_1) { (Time.at(1704146220).beginning_of_hour + 1.hour).to_i }
      let(:epoch_time_2) { (Time.at(1704214680).beginning_of_hour + 1.hour).to_i }
      let!(:forecast1) { FactoryBot.create(:forecast, epoch_time: epoch_time_1, temperature: 10) }
      let!(:forecast2) { FactoryBot.create(:forecast, epoch_time: epoch_time_2, temperature: 15) }

      it 'update temperature' do
        expect {
          VCR.use_cassette('accuweather_service') do
            AccuweatherService.call
          end
        }.to change { Forecast.count }.from(2).to(24)

        expect(Forecast.find_by(epoch_time: epoch_time_1).temperature).to eq(-5.4)
        expect(Forecast.find_by(epoch_time: epoch_time_2).temperature).to eq(-10.5)
      end
    end
  end
end
