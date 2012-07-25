module Gisele::Analysis
  class Glts

    # Implements a weak equivalence relation based on structural equivalence and equal
    # events and guards.
    class WeakEquivalence < Stamina::TransitionSystem::Equivalence

      def equivalent_systems?(s, t)
        (s.state_count == t.state_count) &&
        (s.edge_count  == t.edge_count)  &&
        (s.alphabet    == t.alphabet)    &&
        (s.data        == t.data)        &&
        (s.c0          == t.c0)
      end

      def equivalent_states?(s, t)
        (s.initial?   == t.initial?) &&
        (s.accepting? == t.accepting?) &&
        (s.error?     == t.error?)
      end

      def equivalent_edges?(e, f)
        (e[:event] == f[:event]) &&
        (e[:bdd]   == f[:bdd])
      end

      def find_edge_counterpart(reference_state, operand_edge)
        expected = operand_edge.marks(:event, :bdd)
        reference_state.out_edges.find{|e| e.marks(:event, :bdd) == expected }
      end

    end # class WeakEquivalence

    def weakly_equivalent?(other, &explain)
      WeakEquivalence.new.call(self, other, &explain)
    end

  end # class Glts
end # module Gisele::Analysis