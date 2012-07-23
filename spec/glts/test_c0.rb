require 'spec_helper'
module Gisele::Analysis
  describe Glts, 'c0' do

    let(:glts){
      Glts.new(s) do |g|
        g.add_state :initial => true
      end
    }

    subject{ glts.c0 }

    context 'when no c0 has been set on the glts' do

      it 'delegates to the session' do
        subject.should eq(s.c0)
      end
    end

    context 'when c0 has been set on the glts' do

      let(:c0){ s.bdd("moving") }

      before do
        glts.c0 = c0
      end

      it 'uses the provided c0' do
        subject.should eq(c0)
      end
    end

  end
end