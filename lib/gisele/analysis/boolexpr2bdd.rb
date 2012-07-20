module Gisele::Analysis
  class Boolexpr2BDD < Sexpr::Processor

    attr_reader :session
    attr_reader :bddi

    def initialize(session, options = {})
      super(options)
      @session = session
      @bddi    = session.cudd_manager.interface(:BDD)
    end

    def on_bool_expr(sexpr)
      apply(sexpr.last)
    end

    def on_bool_not(sexpr)
      with_bdd_apply(sexpr[1..-1]) do |bdd|
        bddi.not(bdd)
      end
    end

    def on_bool_and(sexpr)
      with_bdd_apply(sexpr[1..-1]) do |left, right|
        bddi.and(left, right)
      end
    end

    def on_bool_or(sexpr)
      with_bdd_apply(sexpr[1..-1]) do |left, right|
        bddi.or(left, right)
      end
    end

    def on_var_ref(sexpr)
      session.variable(sexpr.last.to_sym, true).bdd
    end

    def on_bool_lit(sexpr)
      sexpr.last ? bddi.one : bddi.zero
    end

  private

    def with_bdd_apply(terms)
      bdds = terms.map{|term| apply(term).ref}
      res  = yield(*bdds)
      bdds.each{|bdd| bdd.deref}
      res
    end

  end
end