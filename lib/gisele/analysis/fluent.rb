module Gisele::Analysis
  class Fluent < Variable
    include Gisele::Analysis::Session::Utils

    attr_reader :init_events
    attr_reader :term_events

    def initialize(session, name, init_events, term_events, initially)
      super(session, name, initially)
      @init_events = init_events
      @term_events = term_events
    end

    def apply_on_invariant(invariant, event)
      if invariant == zero
        zero
      elsif init_events.include?(event)
        _apply_on_invariant(invariant, true)
      elsif term_events.include?(event)
        _apply_on_invariant(invariant, false)
      else
        invariant
      end
    end

  private

    def _apply_on_invariant(invariant, positive)
      existential = invariant.exist_abstract(bdd).ref
      anded       = (existential & (positive ? bdd : !bdd))
      existential.deref
      anded
    end

  end # class Fluent
end # module Gisele
