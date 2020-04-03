require 'rails_helper'

RSpec.describe StateDaily, type: :model do
  let(:state) { Faker::Address.state_abbr }
  let(:date) { rand(2..50).days.ago.to_date }

  describe 'constructor' do
    it 'takes a state code and a date' do
      expect(described_class.new state: state, date: date).to be_a_kind_of described_class
    end
  end

  describe 'instance methods' do
    subject { described_class.new(state: state, date: date) }

    describe '#url' do
      subject { super().url }

      it { is_expected.to be_a_kind_of URI }

      it 'points to the state daily data endpoint' do
        expect(subject.to_s).to match %r{^https://covidtracking.com/api/states/daily\b([^/]|$)}
      end

      context 'query string' do
        let(:parsed_query) { Faraday::Utils.parse_query subject.query }

        it 'contains the state' do
          expect(parsed_query['state']).to be == state
        end

        it 'contains the date, as a number' do
          expect(parsed_query['date']).to be == date.to_s(:number)
        end
      end
    end

    describe '#fetch!' do
      let(:data) { {'random data' => Faker::Lorem.sentence} }

      before(:each) do
        stub_request(:get, subject.url).to_return status: 200, body: data.to_json, headers: {'Content-Type' => 'application/json'}
      end

      it "makes a GET request to the object's URL" do
        subject.fetch!
        expect(a_request(:get, subject.url)).to have_been_made
      end

      it 'returns the parsed JSON from the request body' do
        expect(subject.fetch!).to be == data
      end
    end
  end
end
