require 'rails_helper'

RSpec.describe StateDaily, type: :model do
  let(:state_abbr) { Faker::Address.state_abbr }
  let(:state) { State.find state_abbr }
  let(:date) { rand(2..50).days.ago.to_date }
  let(:date_range) { date..(date + rand(2..10).days) }

  describe 'constructor' do
    it 'takes a state and a date' do
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
    let(:state_daily) { described_class.new(params) }

    subject { state_daily }

    describe '#url' do
      subject { super().url }

      context 'single date' do
        it { is_expected.to be_a_kind_of String }

        it 'returns the URL of the data request' do
          expect(subject).to be == state_daily.request.url
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

    describe '#request' do
      subject { super().request }

      context 'single date' do
        it { is_expected.to be_a_kind_of Typhoeus::Request }

        it 'points to the COVID Tracking JSON endpoint for the given state and date' do
          expect(subject.url).to be == "https://api.covidtracking.com/v1/states/#{state.abbr.downcase}/#{date.to_s :number}.json"
        end

        it 'is cached for 6 hours' do
          expect(subject.cache_ttl).to be == 6.hours.to_i
        end
      end

      context 'date range' do
        include_context 'date range'

        it { is_expected.to be_a_kind_of Typhoeus::Hydra }

        it 'contains one request for each date in the range' do
          expect(subject.queued_requests.map &:url).to match_array date_range.map {|date| described_class.new(state: state, date: date).request.url }
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
          expect(a_request :get, subject.url).to have_been_made
        end

        it 'returns the URL along with the parsed JSON from the request body' do
          expect(subject.fetch!).to be == [subject.url, data]
        end

        context 'caching' do
          include ActiveSupport::Testing::TimeHelpers

          before(:each) { travel 1.week }
          after(:each) { travel_back }

          it 'makes the request only once within 6 hours' do
            pending "Webmock interferes with caching, so this test actually doesn't work"
            subject.fetch!
            travel(5.hours + 59.minutes)
            subject.fetch!
            expect(a_request :get, subject.url).to have_been_made.once
          end
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

        it 'returns an array of the requests paired with their parsed JSON' do
          expect(subject.fetch!).to match_array urls.map {|date, url| [url, data[date]]}
        end

        it "rejects any responses that don't have a date" do
          stub_request(:get, urls.values.sample).to_return status:  200, body: {'content' => 'no date here'}.to_json
          expect(subject.fetch!.length).to be == urls.length - 1
        end

        it 'rejects any responses that return an error status' do
          stub_request(:get, urls.values.sample).to_return status:  404, body: "This is an error and it's not even JSON."
          expect(subject.fetch!.length).to be == urls.length - 1
        end
      end
    end
  end
end
