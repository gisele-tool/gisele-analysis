module Gisele::Analysis
  class Glts

    def explicit_guards!
      invariants!
      each_edge do |e|
        old_bdd, bdd = e[:bdd], e[:bdd] & e.source[:invariant]
        old_bdd.deref
        bdd.ref
        e[:bdd] = bdd
      end
      self
    end

    def simplify_guards!
      invariants!
      each_edge do |e|
        old_bdd, bdd = e[:bdd], e[:bdd].restrict(e.source[:invariant])
        old_bdd.deref
        bdd.ref
        e[:bdd] = bdd
      end
      self
    end

  end # class Glts
end # module Gisele::Analysis
