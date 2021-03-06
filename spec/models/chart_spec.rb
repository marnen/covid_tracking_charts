require 'rails_helper'

RSpec.describe Chart, type: :model do
  let(:legend) { Faker::Lorem.sentence }

  describe 'constructor' do
    it 'takes a hash where the keys are legend strings and the values are arrays of date-value pairs' do
      expect(described_class.new legend => [[rand(100).days.ago, rand(100)]]).to be_a_kind_of described_class
    end
  end

  describe 'instance methods' do
    let(:length) { rand 10..20 }
    let(:value_limit) { 100 }
    let(:series_count) { rand 2..5 }
    let(:data) do
      Array.new(series_count) do
        dates = Array.new(length) {|i| i.days.from_now.to_date}.shuffle
        values = Array.new(length) { rand value_limit }
        [Faker::Lorem.sentence, dates.zip(values)]
      end.to_h
    end

    let(:chart) { described_class.new data }

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

          before(:each) { data[data.keys.sample][rand length][1] = max_value if defined? max_value }

          context 'no values' do
            let(:data) { {} }

            it 'uses steps of 10' do
              expect(divisions).to be == 10
            end
          end

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
        let(:svg_data) { subject.instance_variable_get(:@data) } # TODO: yes, this is terrible; let's see if we can do better

        it "puts each data series' values into the data array, sorted by date" do
          expected = data.values.map do |pairs|
            sorted_pairs = pairs.sort
            [sorted_pairs.map {|(date, _)| DateTime.parse(date.to_s).to_i }, sorted_pairs.map {|(_, value)| value }]
          end

          expect(svg_data.pluck :data).to be == expected
        end

        it 'uses each legend string as the name of the corresponding data series' do
          expect(svg_data.pluck :title).to be == data.keys
        end

        context 'non-string keys' do
          let(:data) { super().symbolize_keys }

          it 'converts them to strings before using them as legends' do
            expect(svg_data.pluck :title).to be == data.keys.map(&:to_s)
          end
        end
      end
    end
  end
end
