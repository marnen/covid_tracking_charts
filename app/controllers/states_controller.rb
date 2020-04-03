class StatesController < ApplicationController
  def show
    @state = params[:state].upcase
    @date = Date.current
    date_range = (@date - 29.days)..@date
    state_daily = StateDaily.new state: @state, date: date_range

    @urls = state_daily.url
    @data = state_daily.fetch!.to_a.reject {|request| request['date'].nil? }
    values = @data.map {|request| [Date.parse(request['date'].to_s), request['positive']] }
    @chart = Chart.new values
  end
end
