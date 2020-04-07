require 'SVG/Graph/TimeSeries'

class Chart
  CHART_TYPES = {line: :lc}
  LEGEND_POSITIONS = {top: :t}

  attr_reader :pairs

  def initialize(pairs:, legend:)
    @pairs = pairs.sort
    @legend = legend
  end

  def to_graph
    values = pairs.map &:last
    max_value = values.max
    divisions = [max_value.ceil(-Math.log10(max_value)) / 10, 10].max

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
      graph.add_data data: pairs.map {|(date, value)| [date.to_time, value] }.flatten, title: @legend
    end
  end

  private

  def dates
    @dates ||= @pairs.map &:first
  end

  def values
    @values ||= @pairs.map &:last
  end

  def start_date
    @start_date ||= dates.first
  end

  def end_date
    @end_date ||= dates.last
  end
end
