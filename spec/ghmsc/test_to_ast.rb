require 'spec_helper'
module Gisele::Analysis
  describe Ghmsc, "to_ast" do

    subject{ ghmsc.to_ast }

    describe "on a AST-driven ghmsc" do
      let(:ghmsc){
        Ghmsc.new(s) do |g|
          g.ast = meeting_scheduling_sexpr
        end
      }

      it{ should eq(meeting_scheduling_sexpr) }
    end

  end
end