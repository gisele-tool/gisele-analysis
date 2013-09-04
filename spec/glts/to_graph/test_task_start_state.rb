require 'spec_helper'
module Gisele::Analysis
  class Glts
    class ToGraph
      describe TASK_START_STATE do

        let(:glts) {
          Glts.new(s) do |g|
            g.add_state :initial => true
            g.add_n_states(6)
            g.connect(0, 1, :event => "Task:start")
            g.connect(1, 2, :event => "Task:end")
            g.connect(2, 3, :event => "Another:start", :guard => "moving")
            g.connect(3, 4, :event => "Another:start")
            g.connect(3, 5, :event => "YetAnother:start")
          end
        }

        it 'recognizes task start states' do
          (TASK_START_STATE === glts.ith_state(0)).should eq("Task")
        end

        it 'does not recognize non task start states' do
          (TASK_START_STATE === glts.ith_state(1)).should be_nil
          (TASK_START_STATE === glts.ith_state(2)).should be_nil
          (TASK_START_STATE === glts.ith_state(3)).should be_nil
          (TASK_START_STATE === glts.ith_state(4)).should be_nil
          (TASK_START_STATE === glts.ith_state(5)).should be_nil
        end

      end
    end
  end
end
