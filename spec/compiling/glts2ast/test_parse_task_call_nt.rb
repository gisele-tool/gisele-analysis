require 'spec_helper'
module Gisele::Analysis
  module Compiling
    describe Glts2Ast, 'parse_task_call_nt' do

      let(:glts){
        Glts.new(s) do |g|
          g.add_n_states(4)
          g.connect(0, 1, event: "Task:start")
          g.connect(1, 2, event: "Task:end")
          g.connect(2, 3, event: "Other:start")
        end
      }

      def state(i)
        glts.ith_state(i)
      end

      subject{
        Glts2Ast.new.parse_task_call_nt(start, eof)
      }

      context 'on a valid task_call_st state and eof outside' do
        let(:start){ state(0) }
        let(:eof)  { state(3) }

        it{ should eq([ [:task_call_st, "Task"], state(2) ]) }
      end

      context 'on a valid task_call_st state and eof on the edge' do
        let(:start){ state(0) }
        let(:eof)  { state(2) }

        it{ should eq([ [:task_call_st, "Task"], state(2) ]) }
      end

      context 'on a valid task_call_st state and eof in between' do
        let(:start){ state(0) }
        let(:eof)  { state(1) }

        it{ should be_nil }
      end

      context 'on invalid task_call_st state' do
        let(:start){ state(1) }
        let(:eof)  { state(2) }

        it{ should be_nil }
      end

      context 'on another invalid task_call_st state' do
        let(:start){ state(2) }
        let(:eof)  { state(3) }

        it{ should be_nil }
      end

    end
  end
end
