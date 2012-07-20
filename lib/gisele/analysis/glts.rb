module Gisele::Analysis
  class Glts

    def initialize(session)
      @session = session
      @automaton = Stamina::Automaton.new
      yield(self) if block_given?
    end

  end # class Glts
end # module Gisele
