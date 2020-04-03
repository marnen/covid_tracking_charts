class StateDaily
  def initialize(state:, date:)
    @state = state
    @date = date
  end

  def url
    URI('https://covidtracking.com/api/states/daily').tap do |url|
      url.query = Faraday::Utils.build_query state: @state, date: @date.to_s(:number)
    end
  end

  def get!
    JSON.parse Faraday.get(url).body
  end
end
