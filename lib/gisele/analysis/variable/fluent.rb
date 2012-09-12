module Gisele::Analysis
  class Fluent < Variable

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
      with_bdd invariant.exist_abstract(bdd) do |e|
        e & (positive ? bdd : !bdd)
      end
    end

  end # class Fluent
end # module Gisele
