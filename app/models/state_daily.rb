class StateDaily
  def initialize(state:, date:)
    @state = state
    @date = date
  end

  def url
    @url ||= if date_range?
      individuals.map &:url
    else
      URI('https://covidtracking.com/api/states/daily').tap do |url|
        url.query = Faraday::Utils.build_query state: @state, date: @date.to_s(:number)
      end
    end
  end

  def fetch!
    if date_range?
      individuals.map(&:fetch!).reject {|response| response['date'].nil? }
    else
      JSON.parse Faraday.get(url).body
    end
  end

  private

  def date_range?
    @date.kind_of? Range
  end

  def individuals
    @individuals ||= @date.map {|date| self.class.new state: @state, date: date }
  end
end
