class StateDaily
  def initialize(state:, date:)
    @state = state
    @date = date
  end

  def url
    @url ||= date_range? ? individuals.map(&:url) : request.url
  end

  def request
    @request ||= if date_range?
      Typhoeus::Hydra.new.tap do |hydra|
        individuals.each {|individual| hydra.queue individual.request }
      end
    else
      Typhoeus::Request.new('https://covidtracking.com/api/states/daily', params: {state: @state.abbr, date: @date.to_s(:number)}, cache_ttl: 6.hours.to_i)
    end
  end

  def fetch!
    if date_range?
      hydra = request
      requests = hydra.queued_requests.dup
      hydra.run
      requests.map {|request| JSON.parse request.response.body }.reject {|response|  response['date'].nil? }
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

  def _request
    @request ||= Typhoeus::Request.new('https://covidtracking.com/api/states/daily', params: {state: @state.abbr, date: @date.to_s(:number)}, cache_ttl: 6.hours.to_i)
  end
end
