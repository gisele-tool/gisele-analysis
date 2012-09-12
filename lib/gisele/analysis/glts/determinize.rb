module Gisele::Analysis
  class Glts
    class Determinize
      include Mixin::BddManagement

      def initialize(source)
        @session = source.session
        @source  = source.eclosure!
        @target  = Glts.new(@session)
        determinize!
      end
      attr_reader :session, :source, :target

    private

      def determinize!
        # compound states to be explored
        to_explore = []

        # mapping between compound states and new target states
        mapping = Hash.new{|h,k|
          to_explore << k
          h[k] = state = @target.add_state(aggregate_state_data(k.map(&:data)))
        }

        # The initial state
        mapping[@source.initial_states.sort].initial!

        # empty to explore
        while sources = to_explore.shift
          remap(sources).each_pair do |event, (guard, targets)|
            next if guard == zero
            marks = {:event => event, :guard => guard.to_dnf, :bdd => guard}
            @target.connect(mapping[sources], mapping[targets], marks)
          end
        end
      end

      # Computes the delta map of a compound state
      #
      # For each event existing on at least one of the outgoing edges of the compounded
      # states, compute a Hash mapping a guard to a target compound state. As the target
      # is deterministic, there is only one guard and one target state for each such
      # event.
      #
      # Example:
      #   remap([1, 2, 4]) -> {:start => [ [guard, target], :stop => [ [ ...] ] ]}
      #
      def remap(compound)
        map = Hash.new{|h,k| h[k] = [zero, []] }
        compound.each do |s|
          s[:eclosure].each_pair do |target, guard|
            target.out_edges.each do |edge|
              next unless event=edge[:event]
              p_guard, p_states = map[event]
              n_guard, n_states = p_guard | (guard & edge[:bdd]), p_states | [edge.target]
              map[event] = [ n_guard, n_states ]
            end
          end
        end
        map.each_value{|v| v.last.sort!}
        map
      end

      def aggregate_state_data(data)
        data[1..-1].inject(data[0]) do |memo,d|
          memo.merge(d) do |k, v1, v2|
            case k
            when :invariant then (v1 | v2).ref
            when :eclosure  then nil
            when :initial   then v1 | v2
            when :error     then v1 | v2
            when :accepting then v1 | v2
            when :origin    then Array(v1) | Array(v2)
            else
              raise "Unexpected state mark (#{k.inspect}): `#{v1}` vs. `#{v2}`" unless v1==v2
              v1
            end
          end
        end
      end

    end # class Determinize

    # Returns a deterministic version of this glts.
    def determinize
      Determinize.new(self.dup.explicit_guards!).target.simplify_guards!
    end

  end # class Glts
end # Gisele::Analysis
