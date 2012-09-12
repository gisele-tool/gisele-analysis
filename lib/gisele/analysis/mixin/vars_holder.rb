module Gisele::Analysis
  module Mixin
    module VarsHolder

      def variables
        @variables ||= []
      end

      def variable(name, raise_on_missing = false)
        if var = variables.find{|v| v.name==name}
          var
        elsif raise_on_missing
          raise Gisele::NoSuchVariableError, "No such variable `#{name}`"
        end
      end

      def fluent(name, init_events, term_events, initially=nil)
        add_var Fluent.new(session, name, init_events, term_events, initially)
      end

      def trackvar(name, update_events, initially=nil)
        add_var Trackvar.new(session, name, update_events, initially)
      end

      def c0_from_variables
        cube = []
        variables.each do |var|
          next if var.initially.nil?
          cube << (var.initially ? var.bdd : !var.bdd)
        end
        bdd_interface.cube(cube, :bdd)
      end

    private

      def add_var(var)
        var.tap do |v|
          variables << v
          v.install(cudd_manager)
        end
      end

    end # module VarsHolder
  end # module Mixin
end # module Gisele::Analysis