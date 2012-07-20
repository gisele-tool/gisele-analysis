module Gisele
  module Analysis
    class Session

      attr_reader :variables

      def initialize
        @variables = []
      end

      def close
      end

      def fluent(name, init_events, term_events, initially=nil)
        add_var Fluent.new(self, name, init_events, term_events, initially)
      end

      def trackvar(name, update_events, initially=nil)
        add_var Trackvar.new(self, name, update_events, initially)
      end

    private

      def add_var(var)
        variables << var
        var
      end

    end # class Session
  end # module Analysis
end # module Gisele
