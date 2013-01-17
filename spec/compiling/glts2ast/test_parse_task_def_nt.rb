require 'spec_helper'
module Gisele::Analysis
  module Compiling
    describe Glts2Ast, 'parse_task_def_nt' do

      let(:glts){
        Glts.new(s) do |g|
          g.add_n_states(8)
          g.connect(0, 1, event: "Major:start")
          g.connect(1, 2, event: "Middle:start")
          g.connect(2, 3, event: "Minor:start")
          g.connect(3, 4, event: "Minor:end")
          g.connect(4, 5, event: "Middle:end")
          g.connect(5, 6, event: "Major:end")
          g.connect(6, 7, event: "Next:start")
        end
      }

      def state(i)
        glts.ith_state(i)
      end

      subject{
        Glts2Ast.new.parse_task_def_nt(start, eof)
      }

      context 'on a valid task_def state and exact eof' do
        let(:start){ state(0) }
        let(:eof)  { state(6) }

        it{ should eq([ [:task_def, "Major", [:task_def, "Middle", [:task_call_st, "Minor"]]], state(6) ]) }
      end

      context 'on a valid task_def state and correct extra eof' do
        let(:start){ state(0) }
        let(:eof)  { state(7) }

        it{ should eq([ [:task_def, "Major", [:task_def, "Middle", [:task_call_st, "Minor"]]], state(6) ]) }
      end

      context 'on a valid task_def state and correct intra eof' do
        let(:start){ state(0) }
        let(:eof)  { state(3) }

        it{ should be_nil }
      end

      context 'on a task_call_st state and correct extra eof' do
        let(:start){ state(1) }
        let(:eof)  { state(2) }

        it{ should be_nil }
      end

    end
  end
end
