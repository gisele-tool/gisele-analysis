module Gisele::Analysis
  class Glts

    def explicit_guards!
      unless @guards_mode == :explicit
        apply_on_guards!{|g, inv|
          g & inv
        }
        @guards_mode = :explicit
      end
      self
    end

    def simplify_guards!
      unless @guards_mode == :simplified
        apply_on_guards!{|g, inv|
          conj = (g & inv).ref
          result = conj.restrict(inv)
          conj.deref
          result
        }
        @guards_mode = :simplified
      end
      self
    end

  private

    def apply_on_guards!
      invariants!
      each_edge do |e|
        new_guard = yield(e[:guard], e.source[:invariant]).ref
        e[:guard].deref
        e[:guard] = new_guard
      end
      self
    end

  end # class Glts
end # module Gisele::Analysis
