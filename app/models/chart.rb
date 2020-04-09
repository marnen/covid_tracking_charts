require 'SVG/Graph/TimeSeries'

class Chart
  # Expected input:
  # {legend_a => [[date_a1, value_a1], [date_a2, value_a2]...], legend_b => [[...]], ...}
  def initialize(hash)
    @data = hash.transform_values &:sort
  end

  def to_graph
    pairs = @data.values.first
    values = pairs.map &:last
    max_value = values.max
    divisions = [max_value.ceil(-Math.log10(max_value)) / 10, 10].max

    legend = @data.keys.first

    SVG::Graph::TimeSeries.new({
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
      @data.each do |legend, pairs|
        graph.add_data data: pairs.map {|(date, value)| [date.to_time, value] }.flatten, title: legend
      end
    end
  end
end
