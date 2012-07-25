require 'spec_helper'
module Gisele::Analysis
  describe Glts, 'explicit_guards!' do

    let(:session) do
      @session = begin
        s = Session.new
        s.fluent :moving, ["start"], ["stop"]
        s.fluent :closed, ["close"], ["open"]
        s.trackvar :mood, ["measure"]
        s
      end
    end

    let(:glts){
      Glts.new(session) do |g|
        g.add_state :initial => true
        g.add_n_states(4)
        g.connect(0, 1, :guard => "not(moving)", :event =>"start")
        g.connect(0, 2, :guard => "moving", :event =>"stop")
        g.connect(1, 2, :guard => "true", :event =>"stop")
        g.connect(2, 3, :guard => "mood")
        g.connect(2, 4, :guard => "not(mood)")
        g.connect(3, 1, :guard => "true", :event =>"measure")
        g.connect(4, 1, :guard => "true", :event =>"measure")
      end
    }

    subject{ glts.explicit_guards! }

    def guard(i)
      glts.ith_edge(i)[:bdd]
    end

    it{ should eq(glts) }

    it 'sets the guards properly' do
      subject
      guard(0).should eq(bdd "not(moving)")
      guard(1).should eq(bdd "moving")
      guard(2).should eq(bdd "true")
      guard(3).should eq(bdd "not(moving) and mood")
      guard(4).should eq(bdd "not(moving) and not(mood)")
      guard(5).should eq(bdd "not(moving) and mood")
      guard(6).should eq(bdd "not(moving) and not(mood)")
    end

  end
end
