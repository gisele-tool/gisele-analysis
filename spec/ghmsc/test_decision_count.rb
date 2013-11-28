require 'spec_helper'
module Gisele::Analysis
  describe Ghmsc, "decision_count" do

    subject{ ghmsc.decision_count }

    let(:ghmsc){
      s = Compiling::Ast2Session.call(meeting_scheduling_sexpr)
      Ghmsc.new(s) do |g|
        g.ast = meeting_scheduling_sexpr
      end
    }

    it{ should eq(2) }

  end
end
