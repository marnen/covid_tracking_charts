class StateSelectorCell < Cell::ViewModel
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormOptionsHelper

  attr_reader :states, :url

  def initialize(states, options)
    super
    @states = states
    @url = options[:url]
  end

  def show
    render
  end

  private

  def locale_state_options
    @locale_state_options ||= states_for_menu.sort_by {|state| _(state.name)}.map {|state| [_(state.name), state.abbr]}
  end

  def states_for_menu
    @states_for_menu ||= State.all
  end
end
