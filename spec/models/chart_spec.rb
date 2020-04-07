require 'rails_helper'

RSpec.describe Chart, type: :model do
  let(:legend) { Faker::Lorem.sentence }

  describe 'constructor' do
    it 'takes an array of date-value pairs and a legend string' do
      expect(described_class.new pairs: [[rand(100).days.ago, rand(100)]], legend: legend).to be_a_kind_of described_class
    end
  end

  describe 'instance methods' do
    let(:length) { rand 10..20 }
    let(:value_limit) { 100 }
    let(:values) { Array.new(length) { rand value_limit } }
    let(:dates) { Array.new(length) {|i| i.days.from_now.to_date}.shuffle }
    let(:pairs) { dates.zip values }
    let(:sorted_pairs) { pairs.sort }
    let(:chart) { described_class.new(pairs: pairs, legend: legend) }

    describe '#pairs' do
      it 'returns the date-value pairs, sorted by date' do
        expect(chart.pairs).to be == sorted_pairs
      end
    end

    describe '#to_graph' do
      subject { chart.to_graph }

      it { is_expected.to be_a_kind_of SVG::Graph::TimeSeries }

      it "sets the chart's size to 800x600" do
        expect(subject.width).to be == 800
        expect(subject.height).to be == 600
      end

      it 'uses short date for the label format' do
        expect(subject.x_label_format).to be == '%d %b'
      end

      it 'formats all numbers as integers' do
        expect(subject.number_format).to be == '%d'
      end

      context 'Y scale' do
        context 'minimum' do
          subject { super().min_y_value }

          it { is_expected.to be_zero }
        end

        context 'divisions' do
          let(:divisions) { subject.scale_y_divisions }

          before(:each) { values[rand values.length] = max_value if defined? max_value }

          context 'max 100 or less' do
            it 'uses steps of 10' do
              expect(divisions).to be == 10
            end
          end

          context 'higher numbers, where n is a single digit' do
            let(:n) { rand 1..9 }
            let(:expected) { order_of_magnitude * n.succ / 10 }
            let(:max_value) { rand (order_of_magnitude * n).succ..(order_of_magnitude * n.succ) }

            [100, 1000, 10_000].each do |order_of_magnitude|
              context "max between #{order_of_magnitude}n + 1 and #{order_of_magnitude}(n + 1)" do
                let(:order_of_magnitude) { order_of_magnitude }

                it "uses steps of #{order_of_magnitude / 10}(n + 1)" do
                  expect(divisions).to be(expected), "expected #{expected} for max of #{max_value} but got #{divisions}"
                end
              end
            end
          end
        end
      end

      it 'displays popups on data points' do
        expect(subject.add_popups).to be true
      end

      it 'uses dd Mon yyyy for the date in the popups' do
        expect(subject.popup_format).to be == '%d %b %Y'
      end

      it 'disables the inline stylesheet' do
        expect(subject.inline_style_sheet).to be == '/* */'
      end

      it 'can make a SVG graph' do
        expect { subject.burn_svg_only }.not_to raise_error
      end

      context 'data' do
        let(:data) { subject.instance_variable_get(:@data).first } # TODO: yes, this is terrible; let's see if we can do better

        it 'puts the values into the data array, sorted by date and flattened' do
          expect(data[:data]).to be == [sorted_pairs.map {|pair| DateTime.parse(pair.first.to_s).to_i }, sorted_pairs.map(&:last)]
        end

        it 'uses the legend string as the name of the data series' do
          expect(data[:title]).to be == legend
        end
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
        expect(params['chd']).to be == "a:#{sorted_pairs.map(&:last).join ','}"
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
