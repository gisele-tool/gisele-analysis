module Gisele::Analysis
  module Mixin
    module BddManagement

      def cudd_manager
        session.cudd_manager
      end

      def bdd_interface
        cudd_manager.interface(:BDD)
      end

      def one
        bdd_interface.one
      end

      def zero
        bdd_interface.zero
      end

      def with_bdd(*bdds)
        bdds.each{|bdd| bdd.ref}
        yield(*bdds)
      ensure
        bdds.each{|bdd| bdd.deref}
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

    end # module BddManagement
  end # module Mixin
end # module Gisele::Analysis