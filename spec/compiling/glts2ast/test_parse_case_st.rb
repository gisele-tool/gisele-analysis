require 'spec_helper'
module Gisele::Analysis
  module Compiling
    describe Glts2Ast, 'parse_case_nt' do

      def state(i)
        glts.ith_state(i)
      end

      def bool_expr(s)
        Gisele.ast(Gisele.parse(s, root: :bool_expr))
      end

      subject{
        Glts2Ast.new.parse_case_nt(start, eof)
      }

      context 'on a if/then/else' do
        let(:glts){
          Glts.new(s) do |g|
            g.add_n_states(7)
            g.connect(0, 1, guard: "moving")
            g.connect(0, 2, guard: "not(moving)")
            g.connect(1, 3, event: "Stop:start")
            g.connect(3, 4, event: "Stop:end")
            g.connect(2, 5, event: "Start:start")
            g.connect(5, 4, event: "Start:end")
            g.connect(4, 6, event: "Next:start")
          end
        }
        let(:start){ state(0) }
        let(:eof)  { state(6) }

        let(:ast){
          [:case_st, nil,
            [:when_clause, bool_expr('moving'),
              [:task_call_st, "Stop"]],
            [:when_clause, bool_expr('not(moving)'),
              [:task_call_st, "Start"]]
          ]
        }

        it{ should eq([ast, state(4)]) }
      end

    end
  end
end
