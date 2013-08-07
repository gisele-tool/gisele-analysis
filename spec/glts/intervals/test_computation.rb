require 'spec_helper'
require 'spec_helper'
module Gisele::Analysis
  class Glts
    class Intervals
      describe Computation do

        let(:glts){
          Glts.new(s) do |g|
            g.add_state(:initial => true)
            g.add_n_states(7)
            g.connect(0, 1)
            g.connect(1, 2)
            g.connect(1, 6)
            g.connect(2, 3)
            g.connect(2, 4)
            g.connect(3, 5)
            g.connect(4, 5)
            g.connect(5, 2)
            g.connect(5, 6)
            g.connect(6, 1)
            g.connect(6, 7)
          end
        }

        let(:computation){ Computation.new(glts) }

        def state(i)
          glts.ith_state(i)
        end

        describe 'successors' do

          def successors(*args)
            computation.successors(*args)
          end

          it 'should work on s0' do
            successors([state(0)]).should eq([state(1)].to_set)
          end

          it 'should work on [s0, s1]' do
            successors([state(0), state(1)]).should eq([state(1), state(2), state(6)].to_set)
          end
        end

        describe 'predecessors' do

          def predecessors(*args)
            computation.predecessors(*args)
          end

          it 'should work on s0' do
            predecessors(state(0)).should eq([].to_set)
          end

          it 'should work on s1' do
            predecessors(state(1)).should eq([state(0), state(6)].to_set)
          end
        end

        describe 'call' do

          let(:expected){{
            state(0) => [state(0)].to_set,
            state(1) => [state(1)].to_set,
            state(2) => [state(2), state(3), state(4), state(5)].to_set,
            state(6) => [state(6), state(7)].to_set,
          }}

          it 'should return the expected result' do
            computation.call.should eq(expected)
          end
        end

      end
    end
  end
end
