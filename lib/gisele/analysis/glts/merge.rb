module Gisele::Analysis
  class Glts

    class Merge

      def initialize
        @threshold = 2
      end
      attr_reader :threshold

      def call(glts)
        while true
          best_candidate = glts
          build_candidates(glts).each do |candidate|
            next unless candidate.state_count < best_candidate.state_count
            best_candidate = candidate
          end
          return glts unless (glts.state_count - best_candidate.state_count) >= threshold
          glts = best_candidate
        end
      end

      def build_candidates(glts, candidates = [])
        size = glts.states.size
        (0...size).each do |i|
          ((i+1)...size).each do |j|
            catch (:incompatibility) do
              candidate = glts.dup
              pair      = candidate.ith_states(i, j)
              merge!(candidate, *pair)
              candidates << candidate
            end
          end
        end
        candidates
      end

      def merge!(glts, s, t)
        merge_states(glts, s, t)
        determinize(glts, s)
        s
      end

      # Merge `s` and `t` the brute force way (non-recursive, no edge-merge)
      def merge_states(glts, s, t)
        data = merge_state_data(s.data, t.data)

        # reconnect `t`'s edges to s
        t.in_edges.each do |in_edge|
          source = (in_edge.source == t ? s : in_edge.source)
          glts.connect(source, s, in_edge.data)
        end
        t.out_edges.each do |out_edge|
          target = (out_edge.target == t ? s : out_edge.target)
          glts.connect(s, target, out_edge.data)
        end

        # drop `t` and mark `s` as its representor
        glts.drop_state(t)
        t[:representor] = s

        # set new marks on s
        data.each_pair{|k,v| s[k] = v}
      end

      def determinize(glts, s)
        delta = Hash.new{|h,k| h[k] = [] }
        s.out_edges.each{|e| delta[e[:event]] << e}
        delta.values.each do |(e,f)|
          next if f.nil?

          # take edge targets, through representors
          t1, t2 = e.target, f.target
          t1 = t1[:representor] while t1[:representor]
          t2 = t2[:representor] while t2[:representor]

          # drop edges and reconnect
          edge_data = merge_edge_data(e.data, f.data)
          glts.drop_edges(e, f)
          new_target = (t1==t2 ? t1 : merge!(glts, t1, t2))
          glts.connect(s, new_target, edge_data)
        end
      end

      def merge_state_data(d1, d2)
        d1.merge(d2) do |k,v1,v2|
          case k
          when :invariant
            (v1 | v2).ref
          when :origin
            v1, v2 = Array(v1), Array(v2)
            throw :incompatibility unless (v1 & v2).empty?
            v1 | v2
          when :eclosure
            nil
          else
            raise "Unexpected state marks #{k}: #{v1} vs. #{v2}" unless v1==v2
            v1
          end
        end
      end

      def merge_edge_data(d1, d2)
        d1.merge(d2) do |k,v1,v2|
          case k
          when :bdd   then (v1 | v2).ref
          when :guard then "#{v1} | #{v2}"
          else
            raise "Unexpected edge marks: #{v1} vs. #{v2}" unless v1==v2
            v1
          end
        end
      end

    end # class Merge

    def merge(other)
      union = (self + other).determinize
      Merge.new.call(union.explicit_guards!).simplify_guards!
    end
    alias :| :merge

  end # class Glts
end # module Gisele::Analysis
