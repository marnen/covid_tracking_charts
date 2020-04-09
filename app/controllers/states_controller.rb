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

    chart = Chart.new

    values = values(responses: responses, field: 'total')
    chart.add_dataset(dataset: Dataset.new(pairs: values, legend: "Total"))

    values = values(responses: responses, field: "positive")
    chart.add_data pairs: values, legend: "Positive"

    values = values(responses: responses, field: "negative")
    chart.add_data pairs: values, legend: "Negative"



    burn_svg_only = chart.to_graph.burn_svg_only

    @chart = burn_svg_only.html_safe
  end

  def values(responses:, field:)
    responses.map {|response| [Date.parse(response['date'].to_s), response[field].to_i] }
  end

  def choose
    redirect_to action: :show, state: params[:state].downcase
  end
end
