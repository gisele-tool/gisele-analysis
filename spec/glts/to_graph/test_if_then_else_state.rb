require 'spec_helper'
module Gisele::Analysis
  class Glts
    class ToGraph
      describe IF_THEN_ELSE_STATE do

        let(:glts) {
          Glts.new(s) do |g|
            g.add_state :initial => true
            g.add_n_states(5)
            g.connect(0, 1, :guard => "moving")
            g.connect(0, 2, :guard => "not(moving)")
            g.connect(1, 3, :event => "closed")
            g.connect(1, 4, :event => "closed and moving")
          end
        }

        it 'recognizes decision states' do
          (IF_THEN_ELSE_STATE === glts.ith_state(0)).should be_true
        end

        it 'does not recognize non middle task states' do
          (IF_THEN_ELSE_STATE === glts.ith_state(1)).should be_false
          (IF_THEN_ELSE_STATE === glts.ith_state(2)).should be_false
          (IF_THEN_ELSE_STATE === glts.ith_state(3)).should be_false
          (IF_THEN_ELSE_STATE === glts.ith_state(4)).should be_false
        end

      end
    end
  end
end
