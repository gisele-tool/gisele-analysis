require 'spec_helper'
module Gisele::Analysis
  describe Session, 'c0' do

    let(:session){ Session.new }

    subject{ session.c0 }

    context 'on an empty session' do
      it{ subject.should eq(one) }
    end

    context 'on an session with full deterministic vars' do
      before do
        session.fluent :moving, [], [], false
        session.fluent :closed, [], [], true
      end
      it{ subject.should eq(session.bdd("not(moving) and closed")) }
    end

    context 'on an session with non-deterministic vars' do
      before do
        session.fluent :moving, [], []
        session.fluent :closed, [], [], true
      end
      it{ subject.should eq(session.bdd("closed")) }
    end

    context 'on an session full non-deterministic vars' do
      before do
        session.fluent :moving, [], []
        session.fluent :closed, [], []
      end
      it{ subject.should eq(one) }
    end

  end
end
