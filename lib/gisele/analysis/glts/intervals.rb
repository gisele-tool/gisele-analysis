require 'set'
module Gisele::Analysis
  class Glts
    class Intervals

      def initialize(glts)
        @glts = glts
      end
      attr_reader :glts

      def intervals
        @intervals ||= Computation.new(glts).call.freeze
      end

      def [](s)
        intervals[s]
      end

    private

      class Computation

        def initialize(glts)
          @glts = glts
          @intervals = Hash.new
        end
        attr_reader :glts, :intervals

        def call
          intervals = Hash.new
          explored = Array.new(glts.states.size, false)
          to_explore = [ glts.ith_state(0) ]
          until to_explore.empty?
            # take one and mark it visited
            visited = to_explore.shift
            explored[visited.index] = true

            # build its interval
            interval = extend_interval([ visited ].to_set)
            intervals[visited] = interval

            # add states to be explored: not already explored and having a
            # predecessor in the interval, but not all
            to_explore += successors(interval)
              .reject{|succ| interval.include?(succ) }
              .reject{|succ| explored[succ.index]    }
              .select{|succ|
                pred = predecessors(succ)
                int  = pred & interval
                (int.size > 0) and (int.size < pred.size)
              }
          end
          intervals
        end

        def extend_interval(interval)
          candidates = successors(interval)
            .reject{|succ| interval.include?(succ) }
            .select{|succ| (predecessors(succ) - interval).empty? }
          candidates.empty? ? interval : extend_interval(interval + candidates)
        end

        def successors(interval)
          interval.map{|s| s.out_adjacent_states.to_set }.reduce(&:|)
        end

        def predecessors(state)
          state.in_adjacent_states.to_set
        end
      end

    end # Intervals
  end # class Glts
end # module Gisele::Analysis
