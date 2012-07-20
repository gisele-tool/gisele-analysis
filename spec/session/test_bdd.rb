require 'spec_helper'
module Gisele::Analysis
  describe Session, 'bdd' do

    before(:all) do
      session.fluent :moving, [:start], [:stop]
      session.fluent :closed, [:close], [:open]
    end

    subject{ session.bdd(expr) }

    let(:moving_bdd){ session.variable(:moving).bdd }

    context 'on a BDD' do
      let(:expr){ moving_bdd }

      it{ should eq(moving_bdd) }
    end

    context 'on true' do
      let(:expr){ true }

      it{ should eq(bddi.one) }
    end

    context 'on false' do
      let(:expr){ false }

      it{ should eq(bddi.zero) }
    end

    context 'on a Variable (variable name)' do
      let(:expr){ session.variable(:moving) }

      it{ should eq(moving_bdd) }
    end

    context 'on a Symbol (variable name)' do
      let(:expr){ :moving }

      it{ should eq(moving_bdd) }
    end

    context 'on a sexpr' do
      let(:expr){ Sexpr.sexpr [:bool_expr, [:var_ref, 'moving']] }

      it{ should eq(moving_bdd) }
    end

    context 'on a valid expression' do
      let(:expr){ "not(moving)" }

      it{ should eq(!moving_bdd) }
    end

    context 'on an invalid expression' do
      let(:expr){ "123" }

      it 'raises a ParseError' do
        lambda{
          subject
        }.should raise_error(Citrus::ParseError)
      end
    end

    context 'on missing variables' do
      let(:expr){ "foo" }

      it 'raises a NoSuchVariableError' do
        lambda{
          subject
        }.should raise_error(Gisele::NoSuchVariableError)
      end
    end

  end
end