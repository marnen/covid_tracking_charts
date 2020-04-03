class StatesController < ApplicationController
  def show
    @state = params[:state].upcase
    @date = Date.current
    requests = ((@date - 29.days)..@date).map do |date|
      StateDaily.new state: @state, date: date
    end
    @urls = requests.map &:url
    @data = requests.map(&:fetch!).reject {|request| request['date'].nil? }
    values = @data.map {|request| [Date.parse(request['date'].to_s), request['positive']] }
    @chart = Chart.new values
  end
end
