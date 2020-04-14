class ChartCell < Cell::ViewModel
  private

  def data
    model
  end

  def chart_data
    @chart_data ||=
    data.transform_values do |requests|
      requests.map {|(_, response)| [Date.parse(response['date'].to_s), response['positive']] }
    end
  end

  def chart
    @chart ||= Chart.new(chart_data).to_graph.burn_svg_only
  end
end
