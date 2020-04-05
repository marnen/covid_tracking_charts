class Chart
  CHART_TYPES = {line: :lc}
  LEGEND_POSITIONS = {top: :t}

  attr_reader :pairs

  def initialize(pairs:, legend:)
    @pairs = pairs.sort
    @legend = legend
  end

  def url
    chart_type = CHART_TYPES[:line]
    data = values
    size = '800x600'
    axes = 'x,y'
    axis_labels = [start_date, end_date].map {|date| date.to_s :short }
    axis_styles = "0,#{COLORS[:text]}|1,#{COLORS[:text]}"
    position = LEGEND_POSITIONS[:top]
    legend_color = COLORS[:text]
    line_thickness = 3
    background = "bg,s,#{COLORS[:background]}"

    URI('https://image-charts.com/chart?').tap do |url|
      params = {
        cht: chart_type,
        chd: "a:#{data.join ','}",
        chs: size,
        chxt: axes,
        chxl: "0:#{axis_labels.map {|label| label.prepend '|' }.join }",
        chxs: axis_styles,
        chdl: @legend,
        chdlp: position,
        chdls: legend_color,
        chco: COLORS[:series],
        chls: line_thickness,
        chf: background
      }
      url.query = URI.encode_www_form params
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
