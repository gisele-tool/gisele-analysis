module Gisele::Analysis
  class Glts
    module State

      def tclosure
        automaton.tclosure! if self[:tclosure].nil?
        self[:tclosure]
      end

      def eof?
        out_edges.size == 0
      end

      def task_start?
        return false unless out_edges.size == 1
        (edge = out_edges.first).start_event?
      end

      def task_end?
        return false unless in_edges.size == 1
        (edge = in_edges.first).end_event?
      end

      def task_middle?
        return false unless in_edges.size == 1 and out_edges.size == 1
        ine, oute = in_edges.first, out_edges.first
        ine.start_event? and oute.end_event? and ine.task_name == oute.task_name
      end

      def binary_decision?
        return false unless out_edges.size == 2 and out_edges.all?{|e| e.guarded? }
        e1, e2 = out_edges
        e1.guard == !e2.guard
      end

      def end_companion
        candidates = out_edges.map{|e| e.target.tclosure}
                              .reduce(:&)
        selected   = candidates.select{|s| s.tclosure == candidates }
        raise "Multiple end companions" unless selected.size == 1
        selected.first
      end

    end # module State
  end # class Glts
end # module Gisele::Analysis
