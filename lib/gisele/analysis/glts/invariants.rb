module Gisele::Analysis
  class Glts
    class Invariants < Stamina::Utils::Decorate
      include Mixin::BddUtils

      def initialize(glts)
        @glts = glts
      end
      attr_reader :glts

      def session
        glts.session
      end

      def suppremum(d0, d1)
        (d0 | d1).ref
      end

      def propagate(deco, edge)
        event = edge[:event]
        deco  = (deco & edge[:bdd]).ref
        session.variables.each do |var|
          old_deco, deco = deco, var.apply_on_invariant(deco, event)
          deco.ref
          old_deco.deref
        end
        deco
      end

      def init_deco(s)
        s.initial? ? glts.c0 : zero
      end

      def take_at_start?(s)
        s.initial?
      end

    end # class Invariants

    def invariants!
      unless @invariants_generated
        Invariants.new(self).call(self, :invariant)
        @invariants_generated = true
      end
      self
    end

  end # class Glts
end # module Gisele::Analysis
