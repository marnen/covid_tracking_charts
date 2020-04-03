class StatesController < ApplicationController
  def show
    @state = params[:state].upcase
    @date = Date.current
    requests = ((@date - 29.days)..@date).map do |date|
      StateDaily.new state: @state, date: date
    end
    @urls = requests.map &:url
    @data = requests.map(&:fetch!).reject {|request| request['date'].nil? }.sort_by {|request| request['date'] }
    values = @data.pluck 'positive'
    @chart = Chart.new values
  end
end
