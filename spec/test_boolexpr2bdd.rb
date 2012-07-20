require 'spec_helper'
module Gisele::Analysis
  describe Boolexpr2BDD do

    let(:parsed){ Gisele.parse(expr, :root => :bool_expr) }
    let(:sexpr) { Gisele.sexpr(parsed)                    }

    subject{
      Boolexpr2BDD.new(session).call(sexpr) 
    }

    before(:all) do
      session.fluent :moving, [:start], [:stop]
      session.fluent :closed, [:close], [:open]
    end

    context "on 'true'" do
      let(:expr){ "true" }

      it { should eq(bddi.one) }
    end

    context "on 'false'" do
      let(:expr){ "false" }

      it { should eq(bddi.zero) }
    end

    context "on 'moving'" do
      let(:expr){ "moving" }
      
      it { should eq(session.variable(:moving).bdd) }
    end

    context "on 'foo'" do
      let(:expr){ "foo" }
      
      it 'should raise a Gisele::NoSuchVariableError' do
        lambda{
          subject
        }.should raise_error(Gisele::NoSuchVariableError, "No such variable `foo`")
      end
    end

    context "on 'not(moving)'" do
      let(:expr){ "not(moving)" }
      
      it { should eq(!session.variable(:moving).bdd) }
    end

    context "on 'moving and closed'" do
      let(:expr){ "moving and closed" }
      
      it { should eq(session.variable(:moving).bdd & session.variable(:closed).bdd) }
    end

    context "on 'moving or closed'" do
      let(:expr){ "moving or closed" }
      
      it { should eq(session.variable(:moving).bdd | session.variable(:closed).bdd) }
    end


  end
end