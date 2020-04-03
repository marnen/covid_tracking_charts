class StatesController < ApplicationController
  def show
    @state = params[:state].upcase
    @date = Date.current
    api = Faraday.new(
      url: 'https://covidtracking.com/api/states/daily', params: {state: @state, date: @date.to_s(:number)}
    )
    @url = api.build_url
    @json = api.get.body
  end
end
