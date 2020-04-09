class Query
  attr_reader :client

  def initialize(states:, date_range:, client: StateDaily)
    @states = states
    @date_range = date_range
    @client = client
  end

  def raw_data
    @raw_data ||= @states.to_h {|state| [state, client.new(state: state, date: @date_range).fetch!] }
  end
end
