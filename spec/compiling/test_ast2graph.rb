require 'spec_helper'
module Gisele
  module Analysis
    module Compiling
      describe Ast2Graph do

        it 'returns an array of Digraphs when called on a unit_def' do
          got = Ast2Graph.call(meeting_scheduling_sexpr)
          got.should be_a(Yargi::Digraph)
        end

      end
    end
  end
end