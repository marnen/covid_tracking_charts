class StateDaily
  def initialize(state:, date:)
    @state = state
    @date = date
  end

  def url
    @url ||= date_range? ? individuals.map(&:url) : request.url
  end

  def fetch!
    if date_range?
      individuals.map(&:fetch!).reject {|response| response['date'].nil? }
    else
      JSON.parse request.run.body
    end
  end

  private

  def date_range?
    @date.kind_of? Range
  end

  def individuals
    @individuals ||= @date.map {|date| self.class.new state: @state, date: date }
  end

  def request
    @request ||= Typhoeus::Request.new('https://covidtracking.com/api/states/daily', params: {state: @state, date: @date.to_s(:number)})
  end
end
