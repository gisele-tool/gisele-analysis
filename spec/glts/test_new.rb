require 'spec_helper'
module Gisele::Analysis
  describe Glts, 'new' do

    subject{
      Glts.new(session(true)) do |g|
        g.add_n_states(3)
        g.connect(0, 1, :event => "start")
        g.connect(1, 2, :guard => "moving")
      end
    }

    it 'returns a Glts' do
      subject.should be_a(Glts)
    end

    it 'sets the symbols correctly' do
      subject.ith_edge(0)[:symbol].should eq("start")
      subject.ith_edge(1)[:symbol].should eq("[guard]")
    end

    it 'sets the events correctly' do
      subject.ith_edge(0)[:event].should eq("start")
      subject.ith_edge(1)[:event].should be_nil
    end

    it 'sets the guards correctly' do
      subject.ith_edge(0)[:guard].should be_nil
      subject.ith_edge(1)[:guard].should eq("moving")
    end

    it 'sets the bdds correctly' do
      subject.ith_edge(0)[:bdd].should eq(bddi.one)
      subject.ith_edge(1)[:bdd].should eq(session.bdd(:moving))
    end

  end
end