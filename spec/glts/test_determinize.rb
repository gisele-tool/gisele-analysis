require 'spec_helper'
module Gisele::Analysis
  describe Glts::Determinize do

    let(:s){ session(true) }
    let(:one){ s.bdd_interface.one }

    subject{ glts.determinize }

    context 'on a tree glts' do
      let(:glts){
        Glts.new(s) do |g|
          g.add_state(:initial => true)
          g.add_n_states(4)
          g.connect(0, 1, :guard => "not(moving)")
          g.connect(1, 2, :event => :start)
          g.connect(0, 3, :guard => "moving")
          g.connect(3, 4, :event => :stop)
        end
      }

      it 'computes the expected glts' do
        Path('tmp/tree.dot').write glts.to_dot
        Path('tmp/tree-deterministic.dot').write subject.to_dot
      end
    end

    context 'on a acyclic glts' do
      let(:glts){
        Glts.new(s) do |g|
          g.add_state(:initial => true)
          g.add_n_states(4)
          g.connect(0, 1, :guard => "moving")
          g.connect(1, 2, :event => :start)
          g.connect(0, 3, :guard => "not(moving)")
          g.connect(3, 4, :event => :stop)
          g.connect(1, 3, :guard => "closed")
        end
      }
    
      it 'computes closures correctly' do
        Path('tmp/acyclic.dot').write glts.to_dot
        Path('tmp/acyclic-deterministic.dot').write subject.to_dot
      end
    end
    
    context 'on a dumb cyclic glts' do
      let(:glts){
        Glts.new(s) do |g|
          g.add_state(:initial => true)
          g.add_state
          g.connect(0, 1, :guard => "moving")
          g.connect(1, 0, :guard => "closed")
        end
      }
    
      it 'computes closures correctly' do
        Path('tmp/cyclic.dot').write glts.to_dot
        Path('tmp/cyclic-deterministic.dot').write subject.to_dot
      end
    end

  end
end