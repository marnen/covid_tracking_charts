class StatesController < ApplicationController
  def show
    normalize_states

    @states = State.find params[:states]
    @date = Date.current
    date_range = (@date - 29.days)..@date

    query = Query.new states: @states, date_range: date_range
    @raw_data = query.raw_data
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
