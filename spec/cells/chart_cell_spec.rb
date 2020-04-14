require 'rails_helper'

RSpec.describe ChartCell, type: :cell do
  let(:data) { {Faker::Lorem.sentence => [[nil, OpenStruct.new(date: rand(1..10).days.ago, positive: rand(1000))]]} }

  subject { described_class.new data }

  describe 'constructor' do
    it { is_expected.to be_a_kind_of Cell::ViewModel }
  end

  describe '#show' do
    subject { Capybara.string cell(described_class, data).call }

    it 'renders an SVG chart' do
      expect(subject).to have_selector 'svg'
    end
  end
end
