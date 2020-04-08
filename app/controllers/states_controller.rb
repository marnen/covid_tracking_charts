class StatesController < ApplicationController
  def show
    @states = State.find params[:states].strip.split %r{\W+}
    @date = Date.current
    date_range = (@date - 29.days)..@date

    @requests = {}
    charts = {}

    # TODO: this is awful and needs refactoring once we figure out how this should work for multiple states. Why can't there be a List monad in Ruby?
    @states.each do |state|
      state_daily = StateDaily.new state: state, date: date_range

      urls = state_daily.url
      responses = state_daily.fetch!
      @requests[state] = urls.zip responses # TODO: maybe we can use StateDaily for this instead

      values = responses.map {|response| [Date.parse(response['date'].to_s), response['positive']] }
      charts[state] = Chart.new pairs: values, legend: state.name
    end

    @charts = charts.transform_values {|chart| chart.to_graph.burn_svg_only.html_safe }
  end

  def choose
    redirect_to action: :show, states: params[:states].downcase
  end
end
