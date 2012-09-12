require 'spec_helper'
module Gisele::Analysis
  describe Mixin::BddManagement, 'bdd' do

    let(:holder){ Mixin.new(session, Mixin::VarsHolder, Mixin::BddManagement) }

    before do
      holder.fluent :moving, [], []
    end

    subject{ holder.bdd(expr) }

    context 'on a BDD' do
      let(:expr){ holder.bdd("moving") }

      it{ should eq(holder.bdd("moving")) }
    end

    context 'on true' do
      let(:expr){ true }

      it{ should eq(holder.one) }
    end

    context 'on false' do
      let(:expr){ false }

      it{ should eq(holder.zero) }
    end

    context 'on a Variable (variable name)' do
      let(:expr){ holder.variable(:moving) }

      it{ should eq(holder.bdd("moving")) }
    end

    context 'on a Symbol (variable name)' do
      let(:expr){ :moving }

      it{ should eq(holder.bdd("moving")) }
    end

    context 'on a sexpr' do
      let(:expr){ Sexpr.sexpr [:bool_expr, [:var_ref, 'moving']] }

      it{ should eq(holder.bdd("moving")) }
    end

    context 'on a valid expression' do
      let(:expr){ "not(moving)" }

      it{ should eq(!holder.bdd("moving")) }
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