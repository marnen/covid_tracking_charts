class StatesController < ApplicationController
  def show
    @state = params[:state].upcase
    @date = Date.current
    @url = 'https://covidtracking.com/api/states/daily?' + URI.encode_www_form([['state', @state], ['date', @date.to_s(:number)]])
  end
end
