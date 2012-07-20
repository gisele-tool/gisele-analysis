require 'spec_helper'
module Gisele::Analysis
  describe Session, 'fluent' do

    subject{
      session.fluent :moving, [:start], [:stop], false
    }

    it 'returns a Fluent instance' do
      subject.should be_a(Fluent)
    end

    it 'sets the session correctly' do
      subject.session.should eq(session)
    end

    it 'sets the name correctly' do
      subject.name.should eq(:moving)
    end

    it 'sets the init events correctly' do
      subject.init_events.should eq([:start])
    end

    it 'sets the term events correctly' do
      subject.term_events.should eq([:stop])
    end

    it 'sets the initially correctly' do
      subject.initially.should eq(false)
    end

    it 'supports no initially' do
      f = session.fluent :moving, [], []
      f.initially.should be_nil
    end

  end
end
