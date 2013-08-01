require 'spec_helper'
module Gisele::Analysis
  describe Glts, 'to_dot' do

    subject{
      Glts.new(s) do |g|
        g.add_n_states(3)
        g.connect(0, 1, :event => "start")
        g.connect(1, 2, :guard => "moving")
      end.to_dot
    }

    it 'returns a expected dot output' do
      subject.should eq(<<DOT)
digraph G {
  graph [margin="0" pack="true" rankdir="TB" ranksep="0"];
  0 [color="black" fillcolor="white" fixedsize="true" height="0.6" shape="circle" style="filled" width="0.6"];
  1 [color="black" fillcolor="white" fixedsize="true" height="0.6" shape="circle" style="filled" width="0.6"];
  2 [color="black" fillcolor="white" fixedsize="true" height="0.6" shape="circle" style="filled" width="0.6"];
  0 -> 1 [arrowsize="0.7" label="start"];
  1 -> 2 [arrowsize="0.7" label="[moving]"];
}
DOT
    end

  end
end