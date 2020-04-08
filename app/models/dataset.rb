class Dataset

  attr_reader :pairs
  attr_reader :legend

  def initialize(pairs:, legend:)
    @pairs = pairs.sort
    @legend = legend
  end
end
