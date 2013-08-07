module Gisele::Analysis
  class Glts

    def separate
      dup.separate!
    end

    def separate!
      @guards_mode = nil
      @invariants_generated = nil
      edges.dup.each do |e|
        next if e[:guard] == one
        middle = add_state(:initial => false)
        connect(e.source, middle, e.data.merge(:event => nil))
        connect(middle, e.target, :event => e[:event])
        drop_edge(e)
      end
      self
    end

  end # class Glts
end # module Gisele::Analysis
