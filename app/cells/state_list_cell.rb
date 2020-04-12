class StateListCell < Cell::ViewModel
  include ERB::Util

  def initialize(states, options = {})
    @states = states
  end

  private

  def state_names_and_abbrs
    @states.map.with_index(1) {|state, index| name_and_abbr state, index }
  end

  def name_and_abbr(state, index)
    h(_'%{span}%{state_name}%{_span} (%{state_abbr})') % {
      span: "<span class='state-#{index}'>".html_safe,
      _span: '</span>'.html_safe,
      state_name: _(state.name),
      state_abbr: _(state.abbr)
    }
  end
end
