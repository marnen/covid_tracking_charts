class Chart
  CHART_TYPES = {line: :lc}

  attr_reader :pairs

  def initialize(pairs)
    @pairs = pairs.sort
  end

  def url
    chart_type = CHART_TYPES[:line]
    data = values
    size = '800x600'
    axes = 'x,y'
    axis_labels = [start_date, end_date].map {|date| date.to_s :short }
    line_thickness = 3

    URI('https://image-charts.com/chart?').tap do |url|
      params = {
        cht: chart_type, chd: "a:#{data.join ','}", chs: size, chxt: axes, chxl: "0:#{axis_labels.map {|label| label.prepend '|' }.join }", chls: line_thickness
      }
      url.query = Faraday::Utils.build_query params
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
