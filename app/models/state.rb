class State
  attr_reader :abbr, :name

  def initialize(abbr:, name:)
    @abbr = abbr
    @name = name
  end

  class << self
    def find(abbr)
      states[normalize abbr]
    end

    private

    def normalize(string)
      string.to_s.upcase
    end

    def states
      @states ||= Hash[CS.states(:us).map {|abbr, name| [normalize(abbr), new(abbr: normalize(abbr), name: name)] } ].with_indifferent_access
    end

    private :new
  end
end
