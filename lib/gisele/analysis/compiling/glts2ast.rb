module Gisele
  module Analysis
    module Compiling
      class Glts2Ast

        attr_reader :glts

        def self.call(glts)
          new.call(glts)
        end

        def call(glts)
          @glts = glts.separate.minimize.simplify_guards!
          ast, reached = parse(@glts.initial_state, @glts.end_state)
          raise "Unable to convert glts to an AST" unless reached == @glts.end_state
          [:task_def, "", ast]
        end

        def parse(init, term)
          parse_seq_st(init, term)
        end

        ### sequence

        def parse_seq_st(init, eof)
          ast, cur = [:seq_st], init
          while (cur != eof and parsed = parse_non_terminal(cur, eof))
            sub_ast, cur = parsed
            ast << sub_ast
          end
          if ast.size == 1
            parse_nop_st(init, eof)
          else
            ast.size == 2 ? [ast.last, cur] : [ast, cur]
          end
        end

        ### non-terminals

        def parse_non_terminal(init, eof)
          parse_terminal(init, eof) ||
          parse_if_nt(init, eof) ||
          parse_case_nt(init, eof) ||
          parse_task_call_nt(init, eof) ||
          parse_task_def_nt(init, eof)
        end

        def parse_if_nt(init, eof)
          if cond = parse_binary_decision(init)
            bool_expr, left, right, end_state = cond
            if then_clause = parse(left, end_state)
              if else_clause = parse(right, end_state)
                then_ast, then_reached = then_clause
                else_ast, else_reached = else_clause
                if (then_reached == else_reached) and (then_reached == end_state)
                  [[:if_st, bool_expr, then_ast, [:else_clause, else_ast]], end_state]
                else
                  fail("Invalid if/then/else on #{init}: #{then_reached} vs. #{else_reached} vs. #{end_state}")
                end
              else
                fail("Else clause expected from #{right}")
              end
            else
              fail("Then clause expected from #{left}")
            end
          else
            fail("Binary decision expected from #{init}")
          end
        end

        def parse_case_nt(init, eof)
          if init.decision? and (end_state = init.end_companion)
            ast = [:case_st, nil]
            init.out_edges.each do |e|
              bool_expr = e.to_bool_expr
              return nil if e.target == eof
              if prod = parse(e.target, end_state)
                when_clause, reached = prod
                if reached == end_state
                  ast << [:when_clause, bool_expr, when_clause]
                else
                  fail("Subflow expected at #{e.target}")
                end
              else
                fail("Subflow expected at #{e.target}")
              end
            end
            [ ast, end_state ]
          else
            fail("N-ary decision expected from #{init}")
          end
        end

        def parse_task_def_nt(init, eof)
          start_name, middle = parse_start_event(init)
          return nil unless middle
          return nil if middle == eof
          return nil unless prod = parse(middle, eof)
          ast, reached = prod
          return nil if reached == eof
          end_name, target = parse_end_event(reached)
          return nil unless start_name == end_name
          [[:task_def, start_name, ast], target]
        end

        def parse_task_call_nt(init, eof)
          start_name, middle = parse_start_event(init)
          return nil unless middle
          return nil if middle == eof
          end_name, target   = parse_end_event(middle)
          return nil unless target
          return nil unless start_name == end_name
          [[:task_call_st, start_name], target]
        end

        ### terminals

        def parse_terminal(init, term)
          parse_nop_st(init, term)
        end

        def parse_nop_st(init, term)
          return nil unless init == term
          [[:nop_st], term]
        end

        ### events

        def parse_start_event(init)
          return nil unless init.out_edges.size == 1
          edge = init.out_edges.first
          return nil unless edge.start_event?
          [ edge.task_name, edge.target ]
        end

        def parse_end_event(init)
          return nil unless init.out_edges.size == 1
          edge = init.out_edges.first
          return nil unless edge.end_event?
          [ edge.task_name, edge.target ]
        end

        # guards

        def parse_binary_decision(init)
          return nil unless init.binary_decision?
          return nil unless end_state = init.end_companion
          then_edge, else_edge = init.out_edges
          then_edge, else_edge = else_edge, then_edge if then_edge.target == end_state
          [then_edge.to_bool_expr, then_edge.target, else_edge.target, end_state]
        end

        def fail(msg)
          #puts msg
          nil
        end

      end # class Glts2Ast
    end # module Compiling
  end # module Analysis
end # module Gisele
