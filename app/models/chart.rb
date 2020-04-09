require 'SVG/Graph/TimeSeries'

class Chart
  CHART_TYPES = {line: :lc}
  LEGEND_POSITIONS = {top: :t}

#  def initialize(pairs:, legend:)
#    @datasets = [ Dataset.new( pairs: pairs, legend: legend) ]
#  end

  def initialize
    @datasets = []
  end

  def to_graph
   # values = pairs.map &:last
    max_value = @datasets.map {|dataset| dataset.max_value}.max
    divisions = [max_value.ceil(-Math.log10(max_value)) / 10, 10].max


    gr = SVG::Graph::TimeSeries.new({
                                 height: 600,
                                 width: 800,
                                 x_label_format: '%d %b',
                                 number_format: '%d',
                                 add_popups: true,
                                 popup_format: '%d %b %Y',
                                 min_y_value: 0,
                                 scale_y_divisions: divisions,
                                 inline_style_sheet: '/* */'
                                    })


    gr.tap do |graph|
      @datasets.each do |dataset|
        data = dataset.pairs.map {|(date, value)| [date.to_time, value] }.flatten
        graph.add_data data: data , title: dataset.legend
      end
    end
  end

  def add_data(pairs:, legend:)
    add_dataset dataset: Dataset.new(pairs: pairs, legend: legend)
  end

  def add_dataset(dataset:)
    @datasets.push dataset
  end
end
