class StatesController < ApplicationController
  def show
    normalize_states

    @states = State.find params[:states]
    @date = Date.current
    date_range = (@date - 29.days)..@date

    query = Query.new states: @states, date_range: date_range
    @raw_data = query.raw_data
    chart_data = @raw_data.transform_values do |requests| # TODO: this should probably move into Query
      requests.map {|(_, response)| [Date.parse(response['date'].to_s), response['positive']] }
    end

    @chart = Chart.new(chart_data).to_graph.burn_svg_only.html_safe
  end

  def choose
    redirect_to action: :show, states: Array(params[:states]).join(',').downcase
  end

  private

  def normalize_states
    params[:states] = params[:states].strip.downcase.split(%r{\W+})
    state_abbrs = params[:states]
    sorted_abbrs = state_abbrs.sort
    unless sorted_abbrs == state_abbrs
      redirect_to action: :show, states: sorted_abbrs.join(','), status: :moved_permanently and return
    end
  end
end
