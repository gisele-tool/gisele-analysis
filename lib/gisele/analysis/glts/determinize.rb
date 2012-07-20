module Gisele::Analysis
  class Glts
    class Determinize
      include Session::Utils

      attr_reader :source, :target

      def initialize(source)
        @session = source.session
        @source  = source.eclosure!
        @target  = Glts.new(session)
        determinize!
      end

      private

        def determinize!
          to_explore = []
          mapping = Hash.new{|h,k|
            to_explore << k
            h[k] = state = @target.add_state
          }
          mapping[@source.initial_states.sort].initial!
          while sources = to_explore.shift
            remap(sources).each_pair do |event, (guard, targets)|
              marks = {:event => event, :guard => guard.to_dnf, :bdd => guard}
              @target.connect(mapping[sources], mapping[targets], marks)
            end
          end
        end

        def remap(compound)
          map = Hash.new{|h,k| h[k] = [zero, []]}
          compound.each do |s|
            s[:eclosure].each_pair do |target, guard|
              target.out_edges.each do |edge|
                next unless event=edge[:event]
                p_guard, p_states = map[event]
                map[event] = [ (p_guard | guard), p_states | [edge.target] ]
              end
            end
          end
          map.each_value{|v| v.last.sort!}
          map
        end

    end # class Eremoval

    # Returns a deterministic version of this glts.
    def determinize
      Determinize.new(self).target
    end

  end # class Glts
end # Gisele::Analysis