require 'set'
module Gisele::Analysis
  class Glts

    class Minimize
      include Mixin::BddManagement

      STATE_AGGREGATOR = Stamina::Utils::Aggregator.new{|g|
        g.ignore(:eclosure)
        g.register(:initial, &:|)
        g.register(:accepting, &:&)
        g.register(:error, &:|)
        g.register(:invariant){|v1,v2|
          (v1 | v2).ref
        }
        g.default{|v1,v2|
          raise "Unexpected state marks: #{v1} vs. #{v2}" unless v1==v2
          v1
        }
      }

      attr_reader :glts

      def session
        glts.session
      end

      def call(glts)
        @glts = glts
        while pair = find_compatible_pair
          merge!(*pair)
        end
        glts
      end

    private

      def merge!(s, t)
        data = STATE_AGGREGATOR.merge(s.data, t.data)

        # reconnect `t`'s in edges to s
        t.in_edges.each do |in_edge|
          source = (in_edge.source == t ? s : in_edge.source)
          glts.connect(source, s, in_edge.data)
        end

        # drop `t` and mark `s` as its representor
        glts.drop_state(t)

        # set new marks on s
        data.each_pair{|k,v| s[k] = v}
      end

      def find_compatible_pair
        size = glts.states.size
        (0...size).each do |i|
          ((i+1)...size).each do |j|
            pair = glts.ith_states(i, j)
            return pair if compatible_states?(*pair)
          end
        end
        nil
      end

      def compatible_states?(s, t)
        s_map, t_map = edge_map(s.out_edges), edge_map(t.out_edges)
        return false unless s_map.keys.to_set==t_map.keys.to_set
        s_map.merge(t_map){|evt,e,f| e+f}.values.all?{|(e,f)|
          compatible_edges?(e, f)
        }
      end

      def compatible_edges?(e, f)
        (e.target == f.target) &&
        compatible_instances?(e, f) &&
        compatible_instances?(e, f)
      end

      def compatible_instances?(e, f)
        (e.source[:invariant] & e[:guard]) == (e.source[:invariant] & (e[:guard] | f[:guard]))
      end

      def edge_map(edges)
        edges.each_with_object(Hash.new{|h,k| h[k]=[]}){|e,h| h[e.symbol] << e}
      end

    end # class Minimize

    def minimize
      dup.minimize!
    end

    def minimize!
      Minimize.new.call(simplify_guards!)
    end

  end # class Glts
end # module Gisele::Analysis
