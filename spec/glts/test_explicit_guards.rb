require 'spec_helper'
module Gisele::Analysis
  describe Glts, 'explicit_guards!' do

    let(:glts){
      Glts.new(s) do |g|
        g.add_state :initial => true
        g.add_n_states(4)
        connect(0, 1, :event => :start)
        connect(1, 2, :guard => "closed")
        connect(1, 3, :guard => "not(closed)")
        connect(2, 4, :event => :stop)
      end
    }

    subject{ glts.explicit_guards! }

    def guard(i)
      glts.ith_edge(i)[:bdd]
    end

    it{ should eq(glts) }

    it 'sets the guards properly' do
      subject
      guard(0).should eq(bdd "not(moving) and closed")
      guard(1).should eq(bdd "moving and closed")
      guard(2).should eq(bdd "false")
      guard(3).should eq(bdd "moving and closed")
    end

  end
end
