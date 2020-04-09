class StatesController < ApplicationController
  def show
    params[:states] = params[:states].strip.downcase.split(%r{\W+})
    state_abbrs = params[:states]
    sorted_abbrs = state_abbrs.sort
    unless sorted_abbrs == state_abbrs
      redirect_to action: :show, states: sorted_abbrs.join(','), status: :moved_permanently and return
    end

    @states = State.find state_abbrs
    @date = Date.current
    date_range = (@date - 29.days)..@date

    @requests = {}
    chart_data = {}

    # TODO: this is awful and needs refactoring once we figure out how this should work for multiple states. Why can't there be a List monad in Ruby?
    @states.each do |state|
      state_daily = StateDaily.new state: state, date: date_range

      requests = state_daily.fetch!
      @requests[state] = requests
      values = requests.map {|(_, response)| [Date.parse(response['date'].to_s), response['positive']] }
      chart_data[state.name] = values
    end

    @chart = Chart.new(chart_data).to_graph.burn_svg_only.html_safe
  end

  def choose
    redirect_to action: :show, states: Array(params[:states]).join(',').downcase
  end
end
