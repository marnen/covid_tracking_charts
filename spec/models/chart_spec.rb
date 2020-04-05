require 'rails_helper'

RSpec.describe Chart, type: :model do
  let(:legend) { Faker::Lorem.sentence }

  describe 'constructor' do
    it 'takes an array of date-value pairs and a legend string' do
      expect(described_class.new pairs: [[rand(100).days.ago, rand(100)]], legend: legend).to be_a_kind_of described_class
    end
  end

  describe 'instance methods' do
    let(:pairs) { Array.new(rand 10..20) {|i| [i.days.from_now.to_date, rand(100)] }.shuffle }
    let(:chart) { described_class.new(pairs: pairs, legend: legend) }

    describe '#pairs' do
      it 'returns the date-value pairs, sorted by date' do
        expect(chart.pairs).to be == pairs.sort
      end
    end

    describe '#url' do
      let(:params) { Hash[URI.decode_www_form URI(subject).query] }

      subject { chart.url }

      it 'points to the image-charts API endpoint' do
        expect(subject.to_s).to start_with 'https://image-charts.com/chart?'
      end

      it 'builds a line chart' do
        expect(params['cht']).to be == 'lc'
      end

      it "sets the chart's size to 800x600" do
        expect(params['chs']).to be == '800x600'
      end

      it 'puts the values into the data array, sorted by date' do
        expect(params['chd']).to be == "a:#{pairs.sort.map(&:last).join ','}"
      end

      it 'makes the x and y axes visible' do
        expect(params['chxt']).to be == 'x,y'
      end

      it 'labels the x axis with the dates of the first and last pairs' do
        start_date = chart.pairs.first.first
        end_date = chart.pairs.last.first
        expect(params['chxl']).to be == "0:|#{start_date.to_s :short}|#{end_date.to_s :short}"
      end

      it 'labels the data series with the legend string at top center, in the text color given in COLORS' do
        expect(params).to include 'chdl' => legend, 'chdlp' => 't', 'chdls' => COLORS[:text]
      end

      it 'sets the data series color to the value in COLORS' do
        expect(params['chco']).to be == COLORS[:series]
      end

      it 'sets the line thickness to 3' do
        expect(params['chls'].to_i).to be == 3
      end

      it 'sets the background fill to the value in COLORS' do
        expect(params['chf']).to be == "bg,s,#{COLORS[:background]}"
      end

      it 'sets the axis labels to the text color in COLORS' do
        expect(params['chxs']).to be == "0,#{COLORS[:text]}|1,#{COLORS[:text]}"
      end
    end
  end
end
