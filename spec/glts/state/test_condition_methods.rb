require 'spec_helper'
module Gisele::Analysis
  class Glts
    describe State, 'condition methods' do

      let(:glts){
        Glts.new(s) do |g|
          g.add_n_states(14)

          # a binary decision subgraph
          g.connect(0, 1, guard: "moving")
          g.connect(0, 2, guard: "not(moving)")

          # a n-ary decision subgraph
          g.connect(3, 4, guard: "moving and closed")
          g.connect(3, 5, guard: "not(moving) and closed")
          g.connect(3, 6, guard: "not(closed)")

          # tasks
          g.connect(7, 8, event: "Task:start")
          g.connect(7, 9, event: "Task:end")

          # a mix
          g.connect(10, 11, guard: "moving")
          g.connect(10, 12, guard: "not(moving)")
          g.connect(10, 13, event: "Task:start")
        end
      }

      def state(i)
        glts.ith_state(i)
      end

      describe 'decision?' do

        it 'returns true on binary_decision' do
          state(0).should be_decision
        end

        it 'returns true on nary_decision' do
          state(3).should be_decision
        end

        it 'returns false on all invalid states' do
          glts.states.each do |state|
            next if [0, 3].include?(state.index)
            state.should_not be_binary_decision
          end
        end
      end

      describe 'binary_decision?' do

        it 'returns true on a binary decision state' do
          state(0).should be_binary_decision
        end

        it 'returns false on a nary decision state' do
          state(3).should_not be_binary_decision
        end

        it 'returns false on all invalid states' do
          glts.states.each do |state|
            next if [0, 3].include?(state.index)
            state.should_not be_binary_decision
          end
        end
      end

    end
  end
end
