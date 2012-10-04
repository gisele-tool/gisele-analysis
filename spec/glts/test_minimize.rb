require 'spec_helper'
module Gisele::Analysis
  describe Glts::Minimize do

    before(:all){
      @session = Session.new
      @session.fluent :moving, [:start], [:stop]
      @session.fluent :closed, [:close], [:open]
      @session
    }
    let(:session){
      @session
    }
    after(:all){
      @session.close if session
    }

    subject{ glts.minimize }

    # before do
    #   glts.o("glts")
    #   subject.o("minimized")
    #   expected.o("expected")
    # end

    context 'on a typical glts' do
      let(:glts){
        Glts.new(session) do |g|
          g.add_state(:initial => true)
          g.add_n_states(6)
          g.connect(0, 1, :guard => "not(moving)")
          g.connect(0, 2, :guard => "moving")
          g.connect(1, 3, :event => "foo")
          g.connect(2, 4, :event => "foo")
          g.connect(3, 5, :event => "bar")
          g.connect(4, 6, :event => "bar")
        end
      }
      let(:expected){
        Glts.new(session) do |g|
          g.add_state(:initial => true)
          g.add_n_states(3)
          g.connect(0, 1, :guard => "not(moving)")
          g.connect(0, 1, :guard => "moving")
          g.connect(1, 2, :event => "foo")
          g.connect(2, 3, :event => "bar")
        end
      }
    
      it{ should be_weakly_equivalent(expected) }
    end

    context 'when guards prevent from merging' do
      let(:glts){
        Glts.new(session) do |g|
          g.add_state(:initial => true)
          g.add_n_states(6)
          g.connect(0, 1, :guard => "not(moving)")
          g.connect(0, 2, :guard => "moving")
          g.connect(1, 3, :event => "foo")
          g.connect(2, 4, :event => "foo")
          g.connect(3, 5, :event => "bar", :guard => "closed")
          g.connect(4, 6, :event => "bar", :guard => "not(closed)")
        end
      }
      let(:expected){
        Glts.new(session) do |g|
          g.add_state(:initial => true)
          g.add_n_states(5)
          g.connect(0, 1, :guard => "not(moving)")
          g.connect(0, 2, :guard => "moving")
          g.connect(1, 3, :event => "foo")
          g.connect(2, 4, :event => "foo")
          g.connect(3, 5, :event => "bar", :guard => "closed")
          g.connect(4, 5, :event => "bar", :guard => "not(closed)")
        end
      }

      it{ should be_weakly_equivalent(expected) }
    end

  end
end