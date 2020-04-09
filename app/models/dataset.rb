class Dataset

  attr_reader :legend

  def initialize(pairs:, legend:)
    @pairs = pairs.sort
    @legend = legend
  end

  def pairs
    @pairs.sort
  end

  def dates
    @dates ||= pairs.map &:first
  end

  def values
    @values ||= pairs.map &:last
  end

  def max_value
    @max_value ||= values.map(&:to_i).max
  end

  def min_date
    @min_date ||= dates.first
  end

  def max_date
    @max_date ||= dates.last
  end
end
