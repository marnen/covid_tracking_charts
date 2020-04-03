class Chart
  def initialize(values)
    @values = values
  end

  def url
    URI('https://image-charts.com/chart?').tap do |url|
      params = {
        cht: :lc, # line chart
        chd: "a:#{@values.join ','}",
        chs: '800x600'
      }
      url.query = Faraday::Utils.build_query params
    end
  end
end
