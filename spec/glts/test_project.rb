require 'spec_helper'
module Gisele::Analysis
  describe Glts, "project" do

    let(:glts){
      Glts.new(s) do |g|
        g.add_state(:initial => true)
        g.add_n_states(5)
        g.connect(0, 1, :event => "Process:start")
        g.connect(1, 2, :guard => "moving")
        g.connect(1, 4, :guard => "not(moving)")
        g.connect(2, 3, :event => "StopTrain:start")
        g.connect(3, 4, :event => "StopTrain:end")
        g.connect(4, 5, :event => "Process:end")
      end
    }

    let(:expected){
      Glts.new(s) do |g|
        g.add_state(:initial => true)
        g.add_n_states(4)
        g.connect(0, 1, :event => "Process:start")
        g.connect(1, 2, :event => "StopTrain:start")
        g.connect(2, 3, :event => "StopTrain:end")
        g.connect(3, 4, :event => "Process:end")
      end
    }

    subject do
      glts.project(s.bdd("moving"))
    end

    before do
      glts.c0 = s.bdd(true)
    end

    before do
      glts.o("test")
      subject.o("projected")
    end

    it{ should be_a(Glts) }

    it 'should have expected c0' do
      subject.c0.should eq(s.bdd("moving"))
    end

    # it{ should be_weakly_equivalent(expected) }

  end
end
