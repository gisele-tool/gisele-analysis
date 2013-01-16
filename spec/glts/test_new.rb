require 'spec_helper'
module Gisele::Analysis
  describe Glts, 'new' do

    subject{
      Glts.new(s) do |g|
        g.add_n_states(3)
        g.connect(0, 1, :event => "start")
        g.connect(1, 2, :guard => "moving")
      end
    }

    it 'returns a Glts' do
      subject.should be_a(Glts)
    end

    it 'extends states with the State module' do
      subject.states.all?{|s|
        (Glts::State === s).should be_true
      }
    end

    it 'extends edges with the Edge module' do
      subject.edges.all?{|s|
        (Glts::Edge === s).should be_true
      }
    end

    it 'sets the symbols correctly' do
      subject.ith_edge(0)[:symbol].should eq("start")
      subject.ith_edge(1)[:symbol].should be_nil
    end

    it 'sets the events correctly' do
      subject.ith_edge(0)[:event].should eq("start")
      subject.ith_edge(1)[:event].should be_nil
    end

    it 'sets the bdds correctly' do
      subject.ith_edge(0)[:guard].should eq(bddi.one)
      subject.ith_edge(1)[:guard].should eq(session.bdd(:moving))
    end

  end
end