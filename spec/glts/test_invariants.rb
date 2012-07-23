require 'spec_helper'
module Gisele::Analysis
  describe Glts, "invariants" do

    let(:a_session){
      s = Gisele::Analysis::Session.new
      s.fluent :moving, [:start], [:stop]
      s.fluent :closed, [:close], [:open]
      s.trackvar :mood, [:measure]
      s
    }

    subject{ glts.invariants! }

    def invariant(i)
      glts.ith_state(i)[:invariant]
    end

    let(:glts) {
      Glts.new(a_session) do |g|
        g.add_state :initial => true
        g.add_n_states(4)
        g.connect(0, 1, :guard => "not(moving)", :event => :start)
        g.connect(0, 2, :guard => "moving", :event => :stop)
        g.connect(1, 2, :guard => "true", :event => :stop)
        g.connect(2, 3, :guard => "mood")
        g.connect(2, 4, :guard => "not(mood)")
        g.connect(3, 1, :guard => "true", :event => :measure)
        g.connect(4, 1, :guard => "true", :event => :measure)
      end
    }

    it 'returns the glts' do
      subject.should eq(glts)
    end

    it 'sets the expected invariants' do
      subject
      invariant(0).should eq(a_session.bdd "true")
      invariant(1).should eq(a_session.bdd "true")
      invariant(2).should eq(a_session.bdd "not(moving)")
      invariant(3).should eq(a_session.bdd "not(moving) and mood")
      invariant(4).should eq(a_session.bdd "not(moving) and not(mood)")
    end

  end
end
