class StatesController < ApplicationController
  def show
    @states = State.all
    @state = State.find params[:state]
    @date = Date.current
    date_range = (@date - 29.days)..@date
    state_daily = StateDaily.new state: @state, date: date_range

    @urls = state_daily.url
    @data = state_daily.fetch!
    values = @data.map {|request| [Date.parse(request['date'].to_s), request['positive']] }
    @chart = Chart.new pairs: values, legend: @state.name
  end

  def go
    redirect_to action: :show, state: params[:state].downcase
  end
end
