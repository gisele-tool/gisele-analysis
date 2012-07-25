module Gisele::Analysis
  class Boolexpr2BDD < Sexpr::Processor
    include Session::Utils

    attr_reader :session

    def initialize(session, options = {})
      super(options)
      @session = session
    end

    def on_bool_expr(sexpr)
      apply(sexpr.last)
    end

    def on_bool_not(sexpr)
      with_bdd_apply(sexpr[1..-1]) do |bdd|
        bdd_interface.not(bdd)
      end
    end

    def on_bool_and(sexpr)
      with_bdd_apply(sexpr[1..-1]) do |left, right|
        bdd_interface.and(left, right)
      end
    end

    def on_bool_or(sexpr)
      with_bdd_apply(sexpr[1..-1]) do |left, right|
        bdd_interface.or(left, right)
      end
    end

    def on_var_ref(sexpr)
      session.variable(sexpr.last.to_sym, true).bdd
    end

    def on_bool_lit(sexpr)
      sexpr.last ? one : zero
    end

  private

    def with_bdd_apply(terms)
      bdds = terms.map{|term| apply(term).ref}
      yield(*bdds)
    ensure
      bdds.each{|bdd| bdd.deref} if bdds
    end

  end
end