require 'rails_helper'

RSpec.describe StateDaily, type: :model do
  let(:state) { Faker::Address.state_abbr }
  let(:date) { rand(2..50).days.ago.to_date }
  let(:date_range) { date..(date + rand(2..10).days) }

  describe 'constructor' do
    it 'takes a state code and a date' do
      expect(described_class.new state: state, date: date).to be_a_kind_of described_class
    end

    it 'can take a range for the date' do
      expect(described_class.new state: state, date: date_range).to be_a_kind_of described_class
    end
  end

  describe 'instance methods' do
    shared_context 'date range' do
      before(:each) { params[:date] = date_range }
    end

    let(:params) { {state: state, date: date} }
    subject { described_class.new(params) }

    describe '#url' do
      subject { super().url }

      context 'single date' do
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

      context 'date range' do
        include_context 'date range'

        it { is_expected.to be_a_kind_of Array }

        it 'contains the URLs for each individual date for the state' do
          expected = date_range.map do |date|
            described_class.new(state: state, date: date).url
          end
          expect(subject).to match_array expected
        end
      end
    end

    describe '#fetch!' do
      context 'single date' do
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

      context 'date range' do
        include_context 'date range'

        let(:data) { Hash[date_range.map {|date| [date, {'date' => date.to_s(:number), 'random data' => Faker::Lorem.sentence}] }] }
        let(:urls) do
          Hash[date_range.map do |date|
            [date, described_class.new(date: date, state: state).url]
          end]
        end

        before(:each) do
          urls.each do |date, url|
            stub_request(:get, url).to_return status: 200, body: data[date].to_json, headers: {'Content-Type' => 'application/json'}
          end
        end

        it 'makes a request for each date' do
          subject.fetch!
          urls.values.each {|url| expect(a_request :get, url).to have_been_made }
        end

        it 'returns an array of the parsed JSON from all the requests' do
          expect(subject.fetch!).to match_array data.values
        end
      end
    end
  end
end
