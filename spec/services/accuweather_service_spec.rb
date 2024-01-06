# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccuweatherService do
  include_context 'weather_data'
  describe '#call' do
    let(:body) { weather_data }

    context 'when empty data' do
      it 'fetches and saves weather data' do
        stub_request(:get, /dataservice.accuweather.com/)
          .to_return(status: 200, body: body.to_json, headers: {})

        allow(HTTParty).to receive(:get).and_return(double(parsed_response: body))

        expect do
          AccuweatherService.call
        end.to change { Forecast.count }.by(24)
      end
    end

    context 'when data exist', :aggregate_failures do
      let(:epochtime1) { (Time.at(1704567480).beginning_of_hour + 1.hour).to_i }
      let(:epochtime2) { (Time.at(1704560220).beginning_of_hour + 1.hour).to_i }
      let!(:forecast1) { FactoryBot.create(:forecast, epoch_time: epochtime1, temperature: 10) }
      let!(:forecast2) { FactoryBot.create(:forecast, epoch_time: epochtime2, temperature: 15) }

      it 'fetches and saves weather data' do
        stub_request(:get, /dataservice.accuweather.com/)
          .to_return(status: 200, body: body.to_json, headers: {})

        allow(HTTParty).to receive(:get).and_return(double(parsed_response: body))

        expect do
          AccuweatherService.call
        end.to change { Forecast.count }.from(2).to(24)

        expect(Forecast.find_by(epoch_time: epochtime1).temperature).to eq(-10.0)
        expect(Forecast.find_by(epoch_time: epochtime2).temperature).to eq(-11.5)
      end
    end
  end
end
