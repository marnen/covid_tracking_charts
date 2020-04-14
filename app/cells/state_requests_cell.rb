class StateRequestsCell < Cell::ViewModel
  def initialize(model, _ = {})
    case model
    in {state: state, requests: requests}
      @state = state
      @requests = requests
    else
      raise ArgumentError, ':state and :requests are required'
    end
  end

  private

  attr_reader :state, :requests
end
