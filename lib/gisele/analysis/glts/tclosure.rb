require 'set'
module Gisele::Analysis
  class Glts
    class Tclosure < Stamina::Utils::Decorate

      EMPTY = {}.freeze

      # We work backward, propagatin transitive closures on source states by union
      def backward?
        true
      end

      # The suppremum is the union
      def suppremum(d0, d1)
        d0 | d1
      end

      # Edges have no influence
      def propagate(deco, edge)
        deco
      end

      # Initial decoration 
      def init_deco(s)
        [s].to_set
      end

      def take_at_start?(s)
        true
      end

      def call(*)
        super.tap{|glts|
          glts.states.each{|s| s[:tclosure] = s[:tclosure].to_a.sort}
        }
      end

    end # class Eclosure

    # Ensure that transitive-closure info is present as a state decoration.
    def tclosure!
      Tclosure.new.call(self, :tclosure)
    end

  end # class Glts
end # module Gisele::Analysis
