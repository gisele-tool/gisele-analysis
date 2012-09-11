require 'spec_helper'
module Gisele
  module Analysis
    module Compiling
      describe Ast2Graph do

        it 'returns an array of Digraphs when called on a unit_def' do
          got = Ast2Graph.call(meeting_scheduling_sexpr)
          got.should be_a(Array)
          got.all?{|x| x.is_a? Yargi::Digraph}.should be_true
        end

        it 'returns a Digraph when called on a task_def' do
          got = Ast2Graph.call(meeting_scheduling_sexpr.last)
          got.should be_a(Yargi::Digraph)
        end

      end
    end
  end
end