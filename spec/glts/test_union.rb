require 'spec_helper'
module Gisele::Analysis
  describe Glts, "union" do

    let(:session){
      @session = Session.new
      @session.fluent :moving, [], []
      @session
    }

    let(:left){
      Glts.new(session) do |g|
        g.add_state(:initial => true)
        g.add_state
        g.connect(0, 1, :event => "stop")
        g.c0 = bdd("moving")
      end
    }

    let(:right){
      Glts.new(session) do |g|
        g.add_state(:initial => true)
        g.add_state
        g.connect(0, 1, :event => "start")
        g.c0 = bdd("not(moving)")
      end
    }

    subject{ left + right }

    let(:expected){
      Glts.new(session) do |g|
        g.add_state(:initial => true)
        g.add_n_states(4)
        g.connect(0, 1, :guard => bdd("moving"))
        g.connect(0, 2, :guard => bdd("not(moving)"))
        g.connect(1, 3, :event => "stop")
        g.connect(2, 4, :event => "start")
        g.c0 = bdd("true")
      end
    }

    it { should be_weakly_equivalent(expected) }

  end
end