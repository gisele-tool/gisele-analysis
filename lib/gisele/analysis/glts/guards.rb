module Gisele::Analysis
  class Glts

    def explicit_guards!
      unless @guards_mode == :explicit
        apply_on_guards!{|g, inv| g & inv }
        @guards_mode = :explicit
      end
      self
    end

    def simplify_guards!
      unless @guards_mode == :simplified
        apply_on_guards!{|g, inv| g.restrict(inv) }
        @guards_mode = :simplified
      end
      self
    end

  private

    def apply_on_guards!
      invariants!
      each_edge do |e|
        new_guard = yield(e[:bdd], e.source[:invariant]).ref
        e[:bdd].deref
        e[:bdd], e[:guard] = new_guard, new_guard.to_dnf
      end
      self
    end

  end # class Glts
end # module Gisele::Analysis
