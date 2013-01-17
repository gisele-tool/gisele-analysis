require 'spec_helper'
module Gisele::Analysis
  module Compiling
    describe Glts2Ast, 'parse_binary_decision' do

      def state(i)
        glts.ith_state(i)
      end

      subject{
        Glts2Ast.new.parse_binary_decision(start)
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

        it{ should eq([ [:bool_expr, [:var_ref, "moving"]], state(1), state(2), state(4) ]) }
      end

      context 'on a pure if/then' do
        let(:glts){
          Glts.new(s) do |g|
            g.add_n_states(5)
            g.connect(0, 1, guard: "moving")
            g.connect(0, 2, guard: "not(moving)")
            g.connect(1, 3, event: "Stop:start")
            g.connect(3, 2, event: "Stop:end")
            g.connect(2, 4, event: "Next:start")
          end
        }
        let(:start){ state(0) }

        it{ should eq([ [:bool_expr, [:var_ref, "moving"]], state(1), state(2), state(2) ]) }
      end

      context 'on a reversed if/then' do
        let(:glts){
          Glts.new(s) do |g|
            g.add_n_states(5)
            g.connect(0, 1, guard: "moving")
            g.connect(0, 2, guard: "not(moving)")
            g.connect(2, 3, event: "Stop:start")
            g.connect(3, 1, event: "Stop:end")
            g.connect(1, 4, event: "Next:start")
          end
        }
        let(:start){ state(0) }

        it{ should eq([ [:bool_expr, [:bool_not, [:var_ref, "moving"]]], state(2), state(1), state(1) ]) }
      end

    end
  end
end
