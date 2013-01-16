require 'spec_helper'
module Gisele::Analysis
  class Glts
    describe Edge do

      let(:glts){
        Glts.new(s) do |g|
          g.add_n_states(4)
          g.connect(0, 1, :event => "Task:start")
          g.connect(1, 2, :guard => "moving")
          g.connect(2, 3, :event => "Task:end", :guard => "not(moving)")
        end
      }

      let(:zero_edge){ glts.ith_edge(0) }
      let(:one_edge){ glts.ith_edge(1) }
      let(:second_edge){ glts.ith_edge(2) }

      describe 'event' do

        it 'return the event when existing' do
          zero_edge.event.should == "Task:start"
        end

        it 'return nil when not existing' do
          one_edge.event.should be_nil
        end
      end

      describe 'evented?' do

        it 'return true with an event' do
          zero_edge.should be_evented
          second_edge.should be_evented
        end

        it 'return false when no event' do
          one_edge.should_not be_evented
        end
      end

      describe 'start_event?' do

        it 'return true with a start event' do
          zero_edge.should be_start_event
        end

        it 'return false when no event' do
          one_edge.should_not be_start_event
        end

        it 'return false when an end event' do
          second_edge.should_not be_start_event
        end
      end

      describe 'end_event?' do

        it 'return false with a start event' do
          zero_edge.should_not be_end_event
        end

        it 'return false when no event' do
          one_edge.should_not be_end_event
        end

        it 'return false when an end event' do
          second_edge.should be_end_event
        end
      end

      describe 'task_name' do

        it 'return the task name with an event' do
          zero_edge.task_name.should eq('Task')
          second_edge.task_name.should eq('Task')
        end

        it 'returns nil when no event' do
          one_edge.task_name.should be_nil
        end
      end

      describe 'guarded?' do

        it 'return true when a guard' do
          one_edge.should be_guarded
          second_edge.should be_guarded
        end

        it 'return false when no guard' do
          zero_edge.should_not be_guarded
        end
      end

    end
  end
end