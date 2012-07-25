require 'spec_helper'
module Gisele
  module Analysis
    module Compiling
      describe Ast2Session do

        subject do
          Ast2Session.call(meeting_scheduling_sexpr)
        end

        after do
          subject.close if subject && subject.respond_to?(:close)
        end

        it 'returns a session' do
          subject.should be_a(Session)
        end

        it 'installs the fluent correctly' do
          sc = subject.variable(:secondCycle)
          sc.should be_a(Fluent)
          sc.init_events.should eq(["WeakenConstraints:end", "ExtendDateRange:end"])
          sc.term_events.should eq(["InitiateMeeting:end"])
          sc.initially.should eq(false)
        end

        it 'installs the trackvar correctly' do
          sc = subject.variable(:dateConflict)
          sc.should be_a(Trackvar)
          sc.update_events.should eq(["AcquireConstraints:end", "WeakenConstraints:end"])
          sc.initially.should eq(false)
        end

      end
    end
  end
end