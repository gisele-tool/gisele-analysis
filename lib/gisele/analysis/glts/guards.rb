module Gisele::Analysis
  class Glts

    def explicit_guards!
      apply_on_guards!{|g, inv| g & inv }
    end

    def simplify_guards!
      apply_on_guards!{|g, inv| g.restrict(inv) }
    end

  private

    def apply_on_guards!
      invariants!
      each_edge do |e|
        new_guard = yield(e[:bdd], e.source[:invariant]).ref
        e[:bdd].deref
        e[:bdd] = new_guard
      end
      self
    end

  end # class Glts
end # module Gisele::Analysis
