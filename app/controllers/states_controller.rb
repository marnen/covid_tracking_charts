class StatesController < ApplicationController
  def show
    @states = State.all.sort_by &:name
    @state = State.find params[:state]
    @date = Date.current
    date_range = (@date - 29.days)..@date
    state_daily = StateDaily.new state: @state, date: date_range

    urls = state_daily.url
    responses = state_daily.fetch!
    @requests = urls.zip responses # TODO: maybe we can use StateDaily for this instead

    values = responses.map {|response| [Date.parse(response['date'].to_s), response['positive']] }
    @chart = Chart.new pairs: values, legend: @state.name
  end

  def choose
    redirect_to action: :show, state: params[:state].downcase
  end
end
