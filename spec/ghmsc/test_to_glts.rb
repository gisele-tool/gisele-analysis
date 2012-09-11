require 'spec_helper'
module Gisele::Analysis
  describe Ghmsc, "to_glts" do

    subject{ ghmsc.to_glts }

    let(:ghmsc){
      s = Compiling::Ast2Session.call(meeting_scheduling_sexpr)
      Ghmsc.new(s) do |g|
        g.ast = meeting_scheduling_sexpr
      end
    }

    it{ should be_a(Glts) }

    it 'sets c0 correctly' do
      subject.c0.should_not be_nil
    end
    
  end
end