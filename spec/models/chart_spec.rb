require 'rails_helper'

RSpec.describe Chart, type: :model do
  describe 'constructor' do
    it 'takes an array of values' do
      expect(described_class.new []).to be_a_kind_of described_class
    end
  end

  describe '#url' do
    let(:values) { Array.new(rand 2..10) { rand 100 } }
    let(:params) { Faraday::Utils.parse_query subject.query }

    subject { described_class.new(values).url }

    it 'points to the image-charts API endpoint' do
      expect(subject.to_s).to start_with 'https://image-charts.com/chart?'
    end

    it 'builds a line chart' do
      expect(params['cht']).to be == 'lc'
    end

    it "sets the chart's size to 800x600" do
      expect(params['chs']).to be == '800x600'
    end

    it 'puts the values into the data array' do
      expect(params['chd']).to be == "a:#{values.join ','}"
    end
  end
end
