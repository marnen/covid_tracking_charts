class Chart
  attr_reader :pairs

  def initialize(pairs)
    @pairs = pairs.sort
  end

  def url
    URI('https://image-charts.com/chart?').tap do |url|
      params = {
        cht: :lc, # line chart
        chd: "a:#{values.join ','}",
        chs: '800x600',
        chxt: 'x,y', # axes
        chxl: "0:|#{start_date.to_s :short}|#{end_date.to_s :short}" # axis labels
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
