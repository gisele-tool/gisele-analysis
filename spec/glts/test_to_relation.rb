require 'spec_helper'
module Gisele::Analysis
  describe Glts, 'to_ruby_literal' do

    before(:all){
      @session = Session.new
      @session.fluent :moving, [], []
      @session
    }
    after(:all){
      @session.close if session
    }
    let(:session){ @session }

    let(:glts){
      Glts.new(session) do |g|
        g.add_state :initial => true
        g.add_n_states 4
        g.connect 0, 1, :guard => "not(moving)"
        g.connect 0, 2, :guard => "moving"
        g.connect 1, 3, :event => "start"
        g.connect 2, 4, :event => "stop"
      end
    }

    let(:expected){
      states = Relation([
        Tuple(:index => 0, :initial => true),
        Tuple(:index => 1, :initial => false),
        Tuple(:index => 2, :initial => false),
        Tuple(:index => 3, :initial => false),
        Tuple(:index => 4, :initial => false),
      ])
      edges = Relation([
        Tuple(:index => 0, :from => 0, :to => 1, :event => nil, :guard => "not(moving)"),
        Tuple(:index => 1, :from => 0, :to => 2, :event => nil, :guard => "moving"),
        Tuple(:index => 2, :from => 1, :to => 3, :event => "start", :guard => "true"),
        Tuple(:index => 3, :from => 2, :to => 4, :event => "stop",  :guard => "true"),
      ])
      Relation(:states => states, :edges => edges)
    }

    subject{ glts.to_relation }

    it{ should eq(expected) }

  end
end