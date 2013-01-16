module Gisele::Analysis
  class Glts

    def trim
      dup.trim!
    end

    def trim!
      unless (es = edges.select{|s| s[:guard] == zero}).empty?
        drop_edges(*es)
      end
      invariants!
      unless (ss = states.select{|s| s[:invariant] == zero}).empty?
        drop_states(*ss)
      end
      self
    end

  end # class Glts
end # module Gisele::Analysis
