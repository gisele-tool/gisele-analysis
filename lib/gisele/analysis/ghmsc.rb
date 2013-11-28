module Gisele::Analysis
  class Ghmsc
    include Mixin::BddManagement

    def initialize(session, &bl)
      @session = session
      yield(self) if bl
    end
    attr_reader :session

    attr_accessor :source

    def c0
      with_bdd session.c0 do |s_c0|
        (@c0 || one) & s_c0
      end
    end

    def c0=(c0)
      @c0 = session.bdd(c0)
    end

    def to_ast
      @ast ||= if source
        Gisele.ast(source)
      elsif @glts
        @glts.to_ast
      end
    end
    attr_writer :ast

    def to_graph
      @graph ||= Compiling::Ast2Graph.call(to_ast)
    end
    attr_writer :graph

    def to_glts
      @glts ||= begin
        glts = Compiling::Ast2Glts.call(session, to_ast)
        glts.c0 = @c0 if @c0
        glts
      end
    end
    attr_writer :glts

    def to_dot
      to_graph.to_dot
    end

    def task_count
      to_graph.vertices(->(v){ v["shape"] == "box" }).size
    end

    def decision_count
      to_graph.vertices(->(v){ v["shape"] == "diamond" }).size
    end

    def merge(other)
      Ghmsc.new(session) do |g|
        g.glts = to_glts | other.to_glts
      end
    end
    alias :| :merge

  end # Ghmsc
end # module Gisele::Analysis
