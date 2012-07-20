require 'spec_helper'
module Gisele::Analysis
  describe Session, 'cudd_manager' do

    subject{ session.cudd_manager }

    it 'returns a Cudd::Manager instance' do
      subject.should be_a(Cudd::Manager)
    end

  end
end