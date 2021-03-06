require 'spec_helper'
module Gisele::Analysis
  describe Mixin::VarsHolder, 'trackvar' do

    let(:holder){ Mixin.new(session, Mixin::VarsHolder, Mixin::BddManagement) }

    subject{
      holder.trackvar :big, [:decide], true
    }

    it 'returns a Trackvar instance' do
      subject.should be_a(Trackvar)
    end

    it 'sets the session correctly' do
      subject.session.should eq(session)
    end

    it 'sets the name correctly' do
      subject.name.should eq(:big)
    end

    it 'sets the update events correctly' do
      subject.update_events.should eq([:decide])
    end

    it 'sets the initially correctly' do
      subject.initially.should eq(true)
    end

    it 'supports no initially' do
      t = holder.trackvar :big, []
      t.initially.should be_nil
    end

  end
end
