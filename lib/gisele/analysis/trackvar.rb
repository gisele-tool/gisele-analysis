module Gisele::Analysis
  class Trackvar < Variable

    attr_reader :update_events

    def initialize(session, name, update_events, initially)
      super(session, name, initially)
      @update_events = update_events
    end

  end # class Trackvar
end # module Gisele
