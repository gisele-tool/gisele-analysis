module Gisele::Analysis
  class Session

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
    attr_reader :variables

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

    def add_var(var)
      var.tap do |v|
        variables << v
        v.install(cudd_manager)
      end
    end
    private :add_var

    def c0
      cube = []
      variables.each do |var|
        next if var.initially.nil?
        cube << (var.initially ? var.bdd : !var.bdd)
      end
      bdd_interface.cube(cube, :bdd)
    end

    ### gHMSC MANAGEMENT #################################################################

    def ghmsc(&bl)
      Ghmsc.new(self, &bl)
    end

    ### GLTS MANAGEMENT ##################################################################

    def glts(&bl)
      Glts.new(self, &bl)
    end

    ### BDD MANAGEMENT ###################################################################
    attr_reader :cudd_manager

    def bdd_interface
      cudd_manager.interface(:BDD)
    end

    def bdd(expr)
      case expr
      when Cudd::BDD  then expr
      when Variable   then expr.bdd
      when Symbol     then variable(expr, true).bdd
      when Sexpr      then Compiling::Boolexpr2BDD.call(self, expr)
      when String     then bdd(Gisele.sexpr Gisele.parse(expr, :root => :bool_expr))
      when TrueClass  then bdd_interface.one
      when FalseClass then bdd_interface.zero
      else
        raise ArgumentError, "Unable to compile `#{expr}` to a BDD"
      end
    end

  end # class Session
end # module Gisele
require_relative 'session/utils'