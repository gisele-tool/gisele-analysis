require 'spec_helper'
module Gisele::Analysis
  module Compiling
    describe Glts2Ast, 'parse_nop_st' do

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
        Glts2Ast.new.parse_nop_st(start, eof)
      }

      context 'when start and eof coincide' do
        let(:start){ state(0) }
        let(:eof)  { state(0) }

        it{ should eq([[:nop_st], state(0)]) }
      end

      context 'when start and eof do not coincide' do
        let(:start){ state(0) }
        let(:eof)  { state(1) }

        it{ should be_nil }
      end

    end
  end
end
