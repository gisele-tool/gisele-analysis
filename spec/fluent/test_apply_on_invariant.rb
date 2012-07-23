require 'spec_helper'
module Gisele::Analysis
  describe Fluent, "apply_on_invariant" do

    let(:s){ session(true) }

    subject{ s.variable(:moving).apply_on_invariant(invariant, event) }

    context 'when not an event of interest' do
      let(:invariant){ s.bdd("moving or closed") }
      let(:event){ :alarm }

      it{ should eq(invariant) }
    end

    context 'when an init event' do
      let(:event){ :start }

      context 'on true' do
        let(:invariant){ one }

        it{ should eq(s.bdd("moving")) }
      end

      context 'on false' do
        let(:invariant){ zero }

        it{ should eq(s.bdd("false")) }
      end

      context 'on not(moving)' do
        let(:invariant){ s.bdd("not(moving)") }

        it{ should eq(s.bdd("moving")) }
      end

      context 'on moving' do
        let(:invariant){ s.bdd("moving") }

        it{ should eq(s.bdd("moving")) }
      end

      context 'on not(moving) | closed' do
        let(:invariant){ s.bdd("not(moving) or closed") }

        it{ should eq(s.bdd("moving")) }
      end

      context 'on not(moving) & closed' do
        let(:invariant){ s.bdd("not(moving) and closed") }

        it{ should eq(s.bdd("moving and closed")) }
      end
    end

    context 'when an term event' do
      let(:event){ :stop }

      context 'on true' do
        let(:invariant){ one }

        it{ should eq(s.bdd("not(moving)")) }
      end

      context 'on false' do
        let(:invariant){ zero }

        it{ should eq(s.bdd("false")) }
      end

      context 'on not(moving)' do
        let(:invariant){ s.bdd("not(moving)") }

        it{ should eq(s.bdd("not(moving)")) }
      end

      context 'on moving' do
        let(:invariant){ s.bdd("moving") }

        it{ should eq(s.bdd("not(moving)")) }
      end

      context 'on not(moving) | closed' do
        let(:invariant){ s.bdd("not(moving) or closed") }

        it{ should eq(s.bdd("not(moving)")) }
      end

      context 'on not(moving) & closed' do
        let(:invariant){ s.bdd("moving and closed") }

        it{ should eq(s.bdd("not(moving) and closed")) }
      end
    end

  end
end