module Gisele::Analysis
  class Fluent < Variable

    attr_reader :init_events
    attr_reader :term_events

    def initialize(session, name, init_events, term_events, initially)
      super(session, name, initially)
      @init_events = init_events
      @term_events = term_events
    end

  end # class Fluent
end # module Gisele
