module Gisele::Analysis
  class Glts
    class Project

      def call(glts, c0)
        glts.c0 = c0
        clean(glts)
      end

      def clean(glts)
        glts.invariants!
        glts.explicit_guards!

        # remove unreachable states
        states = glts.states.select{|e| e[:invariant].false? }
        glts.drop_states(*states) unless states.empty?

        # remove false-guarded edges
        edges = glts.edges.select{|e| e[:guard].false? }
        glts.drop_edges(*edges) unless edges.empty?

        states.empty? and edges.empty? ? glts : clean(glts)
        glts
      end

    end

    def project(c0)
      dup.project!(c0)
    end

    def project!(c0)
      Project.new.call(self, c0)
    end

  end # class Glts
end # module Gisele::Analysis
