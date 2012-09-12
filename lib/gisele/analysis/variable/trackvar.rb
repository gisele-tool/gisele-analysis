module Gisele::Analysis
  class Trackvar < Variable

    attr_reader :update_events

    def initialize(session, name, update_events, initially)
      super(session, name, initially)
      @update_events = update_events
    end

    def apply_on_invariant(invariant, event)
      if invariant == zero
        zero
      elsif update_events.include?(event)
        invariant.exist_abstract(bdd)
      else
        invariant
      end
    end

  end # class Trackvar
end # module Gisele
