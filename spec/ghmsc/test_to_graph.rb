require 'spec_helper'
module Gisele::Analysis
  describe Ghmsc, "to_graph" do

    subject{ ghmsc.to_graph }

    let(:ghmsc){
      s = Compiling::Ast2Session.call(meeting_scheduling_sexpr)
      Ghmsc.new(s) do |g|
        g.ast = meeting_scheduling_sexpr
      end
    }

    it{ should be_a(Yargi::Digraph) }

  end
end