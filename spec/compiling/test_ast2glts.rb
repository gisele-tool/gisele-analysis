require 'spec_helper'
module Gisele
  module Analysis
    module Compiling
      describe Ast2Glts do

        let(:process){ meeting_scheduling_sexpr }

        before(:all) do
          @session = Ast2Session.call(process)
        end

        after(:all) do
          @session.close if @session
        end

        subject{ Ast2Glts.call(@session, process) }

        it 'should return a singleton with the expected glts' do
          subject.should be_a(Array)
          (glts = subject.first).should be_a(Glts)
          glts.state_count.should eq(35)
          glts.edge_count.should eq(36)
        end

      end
    end
  end
end