require 'spec_helper'
module Gisele::Analysis
  describe Session, 'fluent' do

    before(:all){ @moving ||= session.fluent :moving, [:start], [:stop], false }

    subject{ session.variable(name) }

    context 'when existing' do
      let(:name){ :moving }

      it 'returns the fluent' do
        subject.should eq(@moving)
      end
    end

    context 'when not existing' do
      let(:name){ :no_such_one }

      it 'returns nil by default' do
        subject.should be_nil
      end

      it 'raises a NoSuchVariableError if requested' do
        lambda{
          session.variable(name, true)
        }.should raise_error(Gisele::NoSuchVariableError)
      end
    end

  end
end
