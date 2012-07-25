module Gisele::Analysis
  class Glts

    def union(other)
      Glts.new(session) do |g|
        init_state = g.add_state(:initial => true)
        add_glts = lambda do |from, to|
          from.dup(to) do |s, t|
            if s.initial?
              t.initial!(false)
              to.connect(init_state, t, :bdd => from.c0, :guard => from.c0.to_dnf)
            end
          end
        end
        add_glts[self,  g]
        add_glts[other, g]
      end
    end
    alias :+ :union

  end # class Glts
end # module Gisele::Analysis
