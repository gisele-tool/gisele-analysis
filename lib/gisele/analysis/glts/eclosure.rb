module Gisele::Analysis
  class Glts
    class Eclosure < Stamina::Utils::Decorate
      include Session::Utils

      EMPTY = {}.freeze

      def initialize(session)
        super(:eclosure)
        @session = session
      end

      def suppremum(d0, d1)
        d0.merge(d1){|k,l,r| (l | r)}
      end

      def propagate(deco, edge)
        if edge.symbol.nil?
          EMPTY
        else
          propagated = {}
          deco.each_pair do |k,v|
            propagated[k] = (v & edge[:bdd])
          end
          propagated
        end
      end

      def init_deco(s)
        {s => one}
      end

      def take_at_start?(s)
        s.in_edges.any?{|e| e[:event].nil? }
      end

      def backward?
        true
      end

    end # class Eclosure

    # Ensure that epsilon-closure info is present as a state decoration.
    def eclosure!
      Eclosure.new(session).call(self)
    end

  end # class Glts
end # module Gisele::Analysis