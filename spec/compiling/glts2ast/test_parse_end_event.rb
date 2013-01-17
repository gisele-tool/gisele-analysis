require 'spec_helper'
module Gisele::Analysis
  module Compiling
    describe Glts2Ast, 'parse_end_event' do

      let(:glts){
        Glts.new(s) do |g|
          g.add_n_states(5)
          g.connect(0, 1, event: "Task:start")
          g.connect(1, 2, event: "Task:end")
          g.connect(2, 3, event: "Other:start")
          g.connect(2, 4, event: "YetA:start")
        end
      }

      def state(i)
        glts.ith_state(i)
      end

      subject{
        Glts2Ast.new.parse_end_event(start)
      }

      context 'on a valid end event state' do
        let(:start){ state(1) }

        it{ should eq([ "Task", state(2) ]) }
      end

      context 'on an invalid end event state' do
        let(:start){ state(0) }

        it{ should be_nil }
      end

      context 'on state with multiple out edges' do
        let(:start){ state(2) }

        it{ should be_nil }
      end

    end
  end
end
