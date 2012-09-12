require 'spec_helper'
module Gisele::Analysis
  describe Mixin::VarsHolder, 'fluent' do

    let(:holder){ Mixin.new(session, Mixin::VarsHolder, Mixin::BddUtils) }

    before{ 
      @moving ||= holder.fluent :moving, [:start], [:stop], false
    }

    subject{ holder.variable(var_name) }

    describe 'when existing' do
      let(:var_name){ :moving }

      it 'returns the fluent' do
        subject.should eq(@moving)
      end
    end

    describe 'when not existing' do
      let(:var_name){ :no_such_one }

      it 'returns nil by default' do
        subject.should be_nil
      end

      it 'raises a NoSuchVariableError if requested' do
        lambda{
          holder.variable(var_name, true)
        }.should raise_error(Gisele::NoSuchVariableError)
      end
    end

  end
end
