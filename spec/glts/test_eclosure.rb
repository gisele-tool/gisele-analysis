require 'spec_helper'
module Gisele::Analysis
  describe Glts::Eclosure do

    subject{ glts.eclosure! }

    context 'on a tree glts' do
      let(:glts){
        Glts.new(s) do |g|
          g.add_state(:initial => true)
          g.add_n_states(4)
          g.connect(0, 1, :guard => "moving")
          g.connect(1, 2, :event => :start)
          g.connect(0, 3, :guard => "not(moving)")
          g.connect(3, 4, :event => :stop)
        end
      }

      it 'computes closures correctly' do
        s0, s1, s2, s3, s4 = subject.states
        s0[:eclosure].should eq({
          s0 => one, 
          s1 => bdd('moving'), 
          s3 => bdd('not(moving)')
        })
        s1[:eclosure].should eq({s1 => one})
        s2[:eclosure].should eq({s2 => one})
        s3[:eclosure].should eq({s3 => one})
        s4[:eclosure].should eq({s4 => one})
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
        s0, s1, s2, s3, s4 = subject.states
        s0[:eclosure].should eq({
          s0 => one, 
          s1 => bdd('moving'), 
          s3 => bdd('not(moving) or (moving and closed)')
        })
        s1[:eclosure].should eq({
          s1 => one,
          s3 => bdd("closed")
        })
        s2[:eclosure].should eq({s2 => one})
        s3[:eclosure].should eq({s3 => one})
        s4[:eclosure].should eq({s4 => one})
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
        s0, s1 = subject.states
        s0[:eclosure].should eq({
          s0 => one, 
          s1 => bdd('moving or (moving and closed)'), 
        })
        s1[:eclosure].should eq({
          s0 => bdd('closed or (closed and moving)'),
          s1 => one
        })
      end
    end

    context 'on complete & disjoint guards on initial state' do
      let(:glts){
        Glts.new(s) do |f|
          x = f.add_state(:initial => true)
          y = f.add_state
          z = f.add_state
          f.connect(x, y, :guard => "moving", :event => "a")
          f.connect(x, y, :guard => "not(moving)")
          f.connect(y, z, :guard => "closed", :event => "b")
        end
      }
      it 'computes closures correctly' do
        s0, s1, s2 = subject.states
        s0[:eclosure].should eq({
          s0 => one,
          s1 => bdd('not(moving)')
        })
        s1[:eclosure].should eq({
          s1 => one
        })
        s2[:eclosure].should eq({
          s2 => one
        })
      end
    end

  end
end