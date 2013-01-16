require 'spec_helper'
module Gisele::Analysis
  describe Glts::Tclosure do

    subject{ glts.tclosure! }

    # context 'on a tree glts' do
    #   let(:glts){
    #     Glts.new(s) do |g|
    #       g.add_state(:initial => true)
    #       g.add_n_states(4)
    #       g.connect(0, 1, :guard => "moving")
    #       g.connect(1, 2, :event => :start)
    #       g.connect(0, 3, :guard => "not(moving)")
    #       g.connect(3, 4, :event => :stop)
    #     end
    #   }
    # 
    #   it 'computes closures correctly' do
    #     s0, s1, s2, s3, s4 = subject.states
    #     s0[:tclosure].should eq([s0, s1, s2, s3, s4])
    #     s1[:tclosure].should eq([s1, s2])
    #     s2[:tclosure].should eq([s2])
    #     s3[:tclosure].should eq([s3, s4])
    #     s4[:tclosure].should eq([s4])
    #   end
    # end
    # 
    # context 'on a dumb cyclic glts' do
    #   let(:glts){
    #     Glts.new(s) do |g|
    #       g.add_state(:initial => true)
    #       g.add_state
    #       g.connect(0, 1, :guard => "moving")
    #       g.connect(1, 0, :guard => "closed")
    #     end
    #   }
    # 
    #   it 'computes closures correctly' do
    #     s0, s1 = subject.states
    #     s0[:tclosure].should eq([s0, s1])
    #     s1[:tclosure].should eq([s0, s1])
    #   end
    # end

    context 'on a typical if/then/else' do
      let(:glts){
        Glts.new(s) do |g|
          g.add_n_states(7)
          g.connect(0, 1, guard: "moving")
          g.connect(0, 2, guard: "not(moving)")
          g.connect(1, 3, event: "Stop:start")
          g.connect(3, 4, event: "Stop:end")
          g.connect(2, 5, event: "Start:start")
          g.connect(5, 4, event: "Start:end")
          g.connect(4, 6, event: "Next:start")
        end
      }

      it 'computes closures correctly' do
        s0, s1, s2, s3, s4, s5, s6 = subject.states
        s0[:tclosure].should eq([s0, s1, s2, s3, s4, s5, s6])
        s1[:tclosure].should eq([s1, s3, s4, s6])
        s2[:tclosure].should eq([s2, s4, s5, s6])
        s3[:tclosure].should eq([s3, s4, s6])
        s4[:tclosure].should eq([s4, s6])
        s5[:tclosure].should eq([s4, s5, s6])
        s6[:tclosure].should eq([s6])
      end
    end

  end
end