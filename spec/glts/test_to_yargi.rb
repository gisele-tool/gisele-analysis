require 'spec_helper'
module Gisele::Analysis
  describe Glts, "to_yargi" do

    let(:glts){
      Glts.new(s) do |g|
        g.add_state(:initial => true)
        g.add_n_states(5)
        g.connect(0, 1, :event => "Process:start")
        g.connect(1, 2, :guard => "moving")
        g.connect(1, 4, :guard => "not(moving)")
        g.connect(2, 3, :event => "StopTrain:start")
        g.connect(3, 4, :event => "StopTrain:end")
        g.connect(4, 5, :event => "Process:end")
      end
    }

    subject do
      glts.to_yargi
    end

    it{ should be_a(Yargi::Digraph) }

    it 'should be as expected' do
      subject.vertex_count.should eq(glts.states.size)
      subject.edge_count.should eq(glts.edges.size)
      subject.edges.first[:event].should eq("Process:start")
    end

  end
end
