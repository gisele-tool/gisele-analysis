module Gisele::Analysis
  class Glts
    class ToYargi

      def call(glts)
        graph = Yargi::Digraph.new
        graph.add_n_vertices(glts.states.count){|v,i|
          v.add_marks(glts.ith_state(i).data)
        }
        glts.edges.each do |edge|
          i, j = edge.source.index, edge.target.index
          graph.connect(i, j, edge.data)
        end
        graph
      end

    end # class ToYargi

    def to_yargi
      ToYargi.new.call(self)
    end

  end # class Glts
end # module Gisele::Analysis
