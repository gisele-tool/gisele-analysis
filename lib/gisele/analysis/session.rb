module Gisele::Analysis
  class Session

    attr_reader :variables
    attr_reader :cudd_manager

    def initialize
      @variables    = []
      @cudd_manager = Cudd.manager
    end

    def close
      @cudd_manager.close if @cudd_manager
    ensure
      @cudd_manager = nil
    end

    ### VARIABLE MANAGEMENT ##############################################################

    def variable(name, raise_on_missing = false)
      if var = variables.find{|v| v.name==name}
        var
      elsif raise_on_missing
        raise Gisele::NoSuchVariableError, "No such variable `#{name}`"
      end
    end

    def fluent(name, init_events, term_events, initially=nil)
      add_var Fluent.new(self, name, init_events, term_events, initially)
    end

    def trackvar(name, update_events, initially=nil)
      add_var Trackvar.new(self, name, update_events, initially)
    end

    ### BDD MANAGEMENT ###################################################################

    def bdd(expr)
      case expr
      when Cudd::BDD then expr
      when Variable  then expr.bdd
      when Symbol    then variable(expr, true).bdd
      when Sexpr     then Boolexpr2BDD.new(self).call(expr)
      when String    then bdd(Gisele.sexpr Gisele.parse(expr, :root => :bool_expr))
      else
        raise ArgumentError, "Unable to compile `#{expr}` to a BDD"
      end
    end

  private

    def add_var(var)
      var.tap do |v|
        variables << v
        v.install(cudd_manager)
      end
    end

  end # class Session
end # module Gisele
