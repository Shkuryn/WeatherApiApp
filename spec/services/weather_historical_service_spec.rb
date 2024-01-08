# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe WeatherHistoricalService do
  let(:subject) { described_class.new }

  describe '#aggregate_temperature' do
    context 'when forecasts exist' do
      let!(:forecast1) do
        FactoryBot.create(:forecast,
                          observation_time: (Time.current - 2.hours).beginning_of_hour,
                          temperature: 10)
      end
      let!(:forecast2) do
        FactoryBot.create(:forecast,
                          observation_time: (Time.current - 1.hours).beginning_of_hour,
                          temperature: 13)
      end
      let!(:forecast3) do
        FactoryBot.create(:forecast,
                          observation_time: (Time.current - 100.days).beginning_of_hour,
                          temperature: 1)
      end

      it { expect(subject.aggregate_temperature(:min)).to eq(10) }
      it { expect(subject.aggregate_temperature(:max)).to eq(13) }
      it { expect(subject.aggregate_temperature(:avg)).to eq(11.5) }
      it 'raises an error for an invalid operation' do
        expect { subject.aggregate_temperature(:unknown_operation) }.to raise_error(ArgumentError)
      end
    end

    context 'when no forecasts' do
      it 'raises not found error', :aggregate_failures do
        expect { subject.aggregate_temperature(:min) }.to raise_error(ActiveRecord::RecordNotFound)
        expect { subject.aggregate_temperature(:max) }.to raise_error(ActiveRecord::RecordNotFound)
        expect { subject.aggregate_temperature(:avg) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#last' do
    context 'when forecast exist' do
      let(:expected_result) { [['2024-01-03 16:00', 13.0]] }
      let!(:forecast1) do
        FactoryBot.create(:forecast,
                          observation_time: Time.current.beginning_of_hour,
                          temperature: 10)
      end
      let!(:forecast2) do
        FactoryBot.create(:forecast,
                          observation_time: (Time.current - 1.hours).beginning_of_hour,
                          temperature: 13)
      end
      let!(:forecast3) do
        FactoryBot.create(:forecast,
                          observation_time: (Time.current - 100.days).beginning_of_hour,
                          temperature: 1)
      end

      it 'returns recent observations' do
        result = subject.last(1, Time.current)

        expect(result.size).to eq(1)
      end
    end

    context 'when no forecast' do
      let(:error_message) { 'Temperature not Found' }

      it 'raises ActiveRecord::RecordNotFound with specific message' do
        expect { subject.last(1, Time.current) }.to raise_error(ActiveRecord::RecordNotFound, error_message)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
