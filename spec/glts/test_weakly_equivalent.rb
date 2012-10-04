require 'spec_helper'
module Gisele::Analysis
  describe Glts, "weakly_equivalent?" do

    subject{ reference.weakly_equivalent?(operand) }

    after do
      subject.should eq(reference.weakly_equivalent?(operand))
    end

    let(:reference) {
      Glts.new(s) do |g|
        g.add_state :initial => true
        g.add_n_states(2)
        g.connect(0, 1, :guard => "moving")
        g.connect(1, 0, :event => "stop")
        g.connect(0, 2, :guard => "not(moving)")
        g.connect(2, 0, :event => "start")
      end
    }

    context 'with an equivalent glts' do
      let(:operand){
        Glts.new(s) do |g|
          g.add_state :initial => true
          g.add_n_states(2)
          g.connect(0, 1, :guard => "moving")
          g.connect(1, 0, :event => "stop")
          g.connect(0, 2, :guard => "not(moving)")
          g.connect(2, 0, :event => "start")
        end
      }
      it{ should be_true }
    end

    context 'with an non equivalent because of events' do
      let(:operand){
        Glts.new(s) do |g|
          g.add_state :initial => true
          g.add_n_states(2)
          g.connect(0, 1, :guard => "moving")
          g.connect(1, 0, :event => "start")
          g.connect(0, 2, :guard => "not(moving)")
          g.connect(2, 0, :event => "stop")
        end
      }
      it{ should be_false }
    end

    context 'with an non equivalent because of guards' do
      let(:operand){
        Glts.new(s) do |g|
          g.add_state :initial => true
          g.add_n_states(2)
          g.connect(0, 1, :guard => "not(moving)")
          g.connect(1, 0, :event => "stop")
          g.connect(0, 2, :guard => "moving")
          g.connect(2, 0, :event => "start")
        end
      }
      it{ should be_false }
    end

    context 'with a non equivalent glts because of c0' do
      let(:operand){
        Glts.new(s) do |g|
          g.c0 = zero
          g.add_state :initial => true
          g.add_n_states(2)
          g.connect(0, 1, :guard => "moving")
          g.connect(1, 0, :event => "stop")
          g.connect(0, 2, :guard => "not(moving)")
          g.connect(2, 0, :event => "start")
        end
      }
      it{ should be_false }
    end

    context 'with two non equivalent glts' do
      let(:reference){
        Glts.new(s) do |g|
          g.add_state(:initial => true)
          g.add_n_states(3)
          g.connect(0, 1, :guard => "not(moving)")
          g.connect(0, 1, :guard => "moving")
          g.connect(1, 2, :event => "foo")
          g.connect(2, 3, :event => "bar")
        end
      }
      let(:operand){
        Glts.new(s) do |g|
          g.add_state(:initial => true)
          g.add_n_states(3)
          g.connect(0, 1, :guard => "not(moving)")
          g.connect(0, 1, :guard => "moving")
          g.connect(1, 2, :event => "foo")
          g.connect(3, 2, :event => "bar")
        end
      }
      it{ should be_false }
    end

  end
end