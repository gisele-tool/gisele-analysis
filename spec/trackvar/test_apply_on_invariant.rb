require 'spec_helper'
module Gisele::Analysis
  describe Trackvar, "apply_on_invariant" do

    let(:s){ session(true) }

    before do
      s.trackvar :speedy, [ :measure ]
    end

    subject{ 
      s.variable(:speedy).apply_on_invariant(invariant, event)
    }

    context 'when not an event of interest' do
      let(:invariant){ s.bdd("closed or speedy") }
      let(:event){ :stop }

      it{ should eq(s.bdd("closed or speedy")) }
    end

    context 'when an updating event' do
      let(:event){ :measure }

      context 'on true' do
        let(:invariant){ one }

        it{ should eq(one) }
      end

      context 'on false' do
        let(:invariant){ zero }

        it{ should eq(zero) }
      end

      context 'on not(speedy)' do
        let(:invariant){ s.bdd("not(speedy)") }

        it{ should eq(one) }
      end

      context 'on speedy' do
        let(:invariant){ s.bdd("speedy") }

        it{ should eq(one) }
      end

      context 'on speedy & closed' do
        let(:invariant){ s.bdd("closed and speedy") }

        it{ should eq(s.bdd("closed")) }
      end

      context 'on speedy| closed' do
        let(:invariant){ s.bdd("closed or speedy") }

        it{ should eq(s.bdd("true")) }
      end

    end

  end
end