require 'rails_helper'

RSpec.describe StateRequestsCell, type: :cell do
  let(:state) { nil }
  let(:requests) { [] }

  subject { described_class.new state: state, requests:  requests }

  describe 'constructor' do
    it { is_expected.to be_a_kind_of Cell::ViewModel }
  end

  describe '#show' do
    let(:state) { State.all.sample }

    subject { Capybara.string cell(described_class, state: state, requests: requests).call }

    it 'renders a <details> element' do
      expect(subject).to have_selector 'details'
    end

    context 'one request' do
      let(:requests) { Faker::Lorem.words number: 1 }

      it 'shows the state name in the summary, followed by "1 request"' do
        expect(subject).to have_selector 'details > summary', text: "#{state.name} (1 request)"
      end
    end

    context 'more than one request' do
      let(:length) { rand 2..10 }
      let(:urls) { Array.new(length) { File.join Faker::Lorem.words(number: rand(2..5)) } }
      let(:responses) { Array.new(length) { {Faker::Lorem.word => Faker::Lorem.sentence} } }
      let(:requests) { urls.zip responses }

      it 'shows the state name in the summary, followed by the number of requests, properly pluralized' do
        expect(subject).to have_selector 'details > summary', text: "#{state.name} (#{requests.length} requests)"
      end

      it 'shows each request as a dl entry, with the URL as the term and the response as the description' do
        subject.find 'dl.raw-data', visible: :all do |raw_data|
          requests.each do |(url, response)|
            expect(raw_data).to have_xpath ".//dt[text()='#{url}']/following-sibling::*[1][self::dd]/code[text()='#{response}']", visible: :all
          end
        end
      end
    end
  end
end
