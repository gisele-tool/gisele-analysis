require 'spec_helper'
module Gisele::Analysis
  class Glts
    describe State, 'task methods' do

      let(:glts){
        Glts.new(s) do |g|
          g.add_n_states(12)

          # a task subgraph
          g.connect(0, 1, event: "Task:start")
          g.connect(1, 2, event: "Task:end")

          # more than two out transitions
          g.connect(3, 4, event: "Task:start")
          g.connect(3, 5, event: "Other:start")

          # a guarded state
          g.connect(6, 7, guard: "moving")

          # a false middle state
          g.connect(8, 9,  event: "Task:start")
          g.connect(9, 10, event: "Task:end")
          g.connect(9, 11, event: "Task:end")
        end
      }

      def state(i)
        glts.ith_state(i)
      end

      describe 'task_start?' do

        it 'returns true on a valid state' do
          state(0).should be_task_start
          state(8).should be_task_start
        end

        it 'returns false on all invalid states' do
          glts.states.each do |state|
            next if [0,8].include?(state.index)
            state.should_not be_task_start
          end
        end
      end

      describe 'task_end?' do

        it 'returns true on a valid state' do
          state(2).should be_task_end
          state(10).should be_task_end
          state(11).should be_task_end
        end

        it 'returns false on all invalid states' do
          glts.states.each do |state|
            next if [2, 10, 11].include?(state.index)
            state.should_not be_task_end
          end
        end
      end

      describe 'task_middle?' do

        it 'returns true on a valid state' do
          state(1).should be_task_middle
        end

        it 'returns false on all invalid states' do
          glts.states.each do |state|
            next if state.index == 1
            state.should_not be_task_middle
          end
        end
      end

      describe 'eof?' do

        it 'returns true on a valid state' do
          [2, 4, 5, 7, 10, 11].each do |i|
            state(i).should be_eof
          end
        end

        it 'returns false on all invalid states' do
          glts.states.each do |state|
            next if [2, 4, 5, 7, 10, 11].include?(state.index)
            state.should_not be_eof
          end
        end
      end

    end
  end
end
