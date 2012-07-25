module Gisele
  module Analysis
    module Compiling
      class Ast2Session < Sexpr::Processor

        def on_unit_def(sexpr)
          @session = Session.new
          apply_all(sexpr.sexpr_body)
          @session
        rescue
          @session.close if @session
          raise
        end

        def on_missing(sexpr)
          apply_all(sexpr.sexpr_body)
        end

        def on_fluent_def(sexpr)
          name, inits, terms, initially = apply_all(sexpr.sexpr_body)
          @session.fluent name.to_sym, inits, terms, initially
        end

        def on_trackvar_def(sexpr)
          name, updates, obsoletes, initially = apply_all(sexpr.sexpr_body)
          @session.trackvar name.to_sym, updates, initially
        end

      private

        def apply_all(array)
          return nil if array.nil?
          array.map{|sexpr| Sexpr===sexpr ? apply(sexpr) : sexpr}
        end

      end
    end # module Ast2Session
  end # module Analysis
end # module Gisele