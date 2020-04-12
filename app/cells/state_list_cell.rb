class StateListCell < Cell::ViewModel
  include ERB::Util

  def initialize(states, options = {})
    @states = states
  end

  private

  attr_reader :states
end
