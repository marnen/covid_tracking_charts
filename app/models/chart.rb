require 'SVG/Graph/TimeSeries'

class Chart
  # Expected input:
  # {legend_a => [[date_a1, value_a1], [date_a2, value_a2]...], legend_b => [[...]], ...}
  def initialize(hash)
    @data = hash.transform_values &:sort
  end

  def to_graph
    @graph ||= SVG::Graph::TimeSeries.new({
      height: 600,
      width: 800,
      x_label_format: '%d %b',
      number_format: '%d',
      add_popups: true,
      popup_format: '%d %b %Y',
      min_y_value: 0,
      scale_y_divisions: divisions,
      inline_style_sheet: '/* */'
    }).tap do |graph|
      data.each do |legend, pairs|
        graph.add_data data: pairs.map {|(date, value)| [date.to_time, value] }.flatten, title: legend.to_s
      end
    end
  end

  private

  attr_reader :data

  def series
    @series ||= @data.values
  end

  def values
    @values ||= series.map {|single_series| single_series.map &:last }
  end

  def max_value
    @max_value ||= values.flatten.max
  end

  def divisions
    @divisions ||= max_value.nil? ? 10 : [max_value.ceil(-Math.log10(max_value)) / 10, 10].max
  end
end
