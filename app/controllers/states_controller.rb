class StatesController < ApplicationController
  def show
    @state = params[:state].upcase
    @date = Date.current
    api = StateDaily.new state: @state, date: @date
    @url = api.url
    @data = api.fetch!
  end
end
