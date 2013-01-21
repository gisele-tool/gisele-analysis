require 'spec_helper'
module Gisele::Analysis
  describe Glts, 'to_ruby_literal' do

    before(:all){
      @session = Session.new
      @session.fluent :moving, [], []
      @session
    }
    after(:all){
      @session.close if session
    }
    let(:session){ @session }

    let(:source){
      <<-SRC.gsub(/^\s*#[ ]/m, "")
      # Glts.new(session) do |g|
      #   g.add_state :initial => true
      #   g.add_n_states 4
      #   g.connect 0, 1, :guard => "not(moving)"
      #   g.connect 0, 2, :guard => "moving"
      #   g.connect 1, 3, :event => "start"
      #   g.connect 2, 4, :event => "stop"
      # end
      SRC
    }

    let(:glts){ eval(source, binding) }

    subject{ glts.to_ruby_literal.strip }

    it{
      should eq(source.strip)
    }

  end
end