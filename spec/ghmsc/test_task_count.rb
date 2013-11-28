require 'spec_helper'
module Gisele::Analysis
  describe Ghmsc, "task_count" do

    subject{ ghmsc.task_count }

    let(:ghmsc){
      s = Compiling::Ast2Session.call(meeting_scheduling_sexpr)
      Ghmsc.new(s) do |g|
        g.ast = meeting_scheduling_sexpr
      end
    }

    it{ should eq(7) }

  end
end
