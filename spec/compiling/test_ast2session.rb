require 'spec_helper'
module Gisele
  module Analysis
    module Compiling
      describe Ast2Session do

        let(:process) do
          Gisele::Language.sexpr <<-PROCESS
            task MeetingScheduling

              fluent secondCycle
                {WeakenConstraints:end, ExtendDateRange:end},
                {InitiateMeeting:end}
              initially false

              fluent initiated {}, {}

              trackvar dateConflict
                {AcquireConstraints:end, WeakenConstraints:end}
              initially true

              trackvar foo {}
            end
          PROCESS
        end

        subject do
          Ast2Session.call(process)
        end

        after do
          subject.close if subject && subject.respond_to?(:close)
        end

        it 'returns a session' do
          subject.should be_a(Session)
        end

        it 'installs the fluents correctly' do
          sc = subject.variable(:secondCycle)
          sc.should be_a(Fluent)
          sc.init_events.should eq(["WeakenConstraints:end", "ExtendDateRange:end"])
          sc.term_events.should eq(["InitiateMeeting:end"])
          sc.initially.should eq(false)

          sc = subject.variable(:initiated)
          sc.initially.should be_nil
        end

        it 'installs the trackvars correctly' do
          sc = subject.variable(:dateConflict)
          sc.should be_a(Trackvar)
          sc.update_events.should eq(["AcquireConstraints:end", "WeakenConstraints:end"])
          sc.initially.should eq(true)

          sc = subject.variable(:foo)
          sc.initially.should be_nil
        end

      end
    end
  end
end