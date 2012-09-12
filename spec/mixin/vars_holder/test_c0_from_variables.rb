require 'spec_helper'
module Gisele::Analysis
  describe Mixin::VarsHolder, 'c0_from_variables' do

    let(:holder){ Mixin.new(session, Mixin::VarsHolder, Mixin::BddManagement) }

    subject{ holder.c0_from_variables }

    context 'on an empty session' do
      it{ should eq(one) }
    end

    context 'on an session with full deterministic vars' do
      before do
        holder.fluent :moving, [], [], false
        holder.fluent :closed, [], [], true
      end
      it{ should eq(holder.bdd("not(moving) and closed")) }
    end

    context 'on an session with non-deterministic vars' do
      before do
        holder.fluent :moving, [], []
        holder.fluent :closed, [], [], true
      end
      it{ should eq(holder.bdd("closed")) }
    end

    context 'on an session full non-deterministic vars' do
      before do
        holder.fluent :moving, [], []
        holder.fluent :closed, [], []
      end
      it{ should eq(one) }
    end

  end
end
