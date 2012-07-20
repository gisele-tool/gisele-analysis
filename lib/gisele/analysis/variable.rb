module Gisele
  module Analysis
    class Variable

      attr_reader :session
      attr_reader :name
      attr_reader :initially

      def initialize(session, name, initially)
        @session = session
        @name = name
        @initially = initially
      end

    end # class Variable
  end # module Analysis
end # module Gisele
