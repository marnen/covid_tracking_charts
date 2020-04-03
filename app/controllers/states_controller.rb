class StatesController < ApplicationController
  def show
    @state = params[:state].upcase
    @date = Date.current
    requests = ((@date - 29.days)..@date).map do |date|
      StateDaily.new state: @state, date: date
    end
    @urls = requests.map &:url
    @data = requests.map &:fetch!
  end
end
