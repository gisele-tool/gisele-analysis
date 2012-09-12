module Gisele
  module Analysis
    module Compiling
      class Processor < Sexpr::Processor
        include Mixin::BddManagement

        attr_reader :session

        def initialize(session, options = {})
          super(options)
          @session = session
        end

        def self.call(session, ast, options = nil)
          new(session, options).call(ast)
        end

      end # class Processor
    end # module Compiling
  end # module Analysis
end # module Gisele