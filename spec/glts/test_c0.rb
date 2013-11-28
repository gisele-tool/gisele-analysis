require 'spec_helper'
module Gisele::Analysis
  describe Glts, 'c0' do

    before do
      s.fluent :specific, [], []
    end

    let(:glts){
      Glts.new(s) do |g|
        g.add_state :initial => true
      end
    }

    subject{ glts.c0 }

    context 'when no c0 has been set on the glts' do

      it 'delegates to the session' do
        subject.should eq(s.c0_from_variables)
      end
    end

    context 'when c0 has been set on the glts' do
      before do
        glts.c0 = "specific"
      end

      it 'takes it as is' do
        subject.should eq(s.bdd("specific"))
      end
    end

  end
end
