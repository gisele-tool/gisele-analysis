require 'spec_helper'
module Gisele::Analysis
  describe Glts, 'explicit_guards!' do

    let(:glts){
      Glts.new(s) do |g|
        g.add_state :initial => true
        g.add_n_states(4)
        g.connect(0, 1, :event => :start, :guard => "not(moving) and closed")
        g.connect(1, 2, :guard => "moving and closed")
        g.connect(1, 3, :guard => "false")
        g.connect(2, 4, :event => :stop, :guard => "moving and closed")
      end
    }

    subject{ glts.simplify_guards! }

    def guard(i)
      glts.ith_edge(i)[:bdd]
    end

    it{ should eq(glts) }

    it 'sets the guards properly' do
      subject
      guard(0).should eq(bdd "true")
      guard(1).should eq(bdd "true")
      guard(2).should eq(bdd "false")
      guard(3).should eq(bdd "true")
    end

  end
end
