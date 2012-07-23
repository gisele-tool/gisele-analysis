require 'spec_helper'
module Gisele::Analysis
  describe Glts::Determinize do

    subject{ glts.determinize }

    context 'on a tree glts' do
      let(:glts){
        Glts.new(s) do |g|
          g.add_state(:initial => true)
          g.add_n_states(4)
          g.connect(0, 1, :guard => "not(moving)")
          g.connect(1, 2, :event => :start)
          g.connect(0, 3, :guard => "moving")
          g.connect(3, 4, :event => :stop)
        end
      }
      let(:expected){
        Glts.new(s) do |g|
          g.add_state(:initial => true)
          g.add_n_states(2)
          g.connect(0, 1, :guard => "not(moving)", :event => :start)
          g.connect(0, 2, :guard => "moving", :event => :stop)
        end
      }

      it{ should be_weakly_equivalent(expected) }
    end

    context 'on a acyclic glts' do
      let(:glts){
        Glts.new(s) do |g|
          g.add_state(:initial => true)
          g.add_n_states(4)
          g.connect(0, 1, :guard => "moving")
          g.connect(1, 2, :event => :start)
          g.connect(0, 3, :guard => "not(moving)")
          g.connect(3, 4, :event => :stop)
          g.connect(1, 3, :guard => "closed")
        end
      }
      let(:expected){
        Glts.new(s) do |g|
          g.add_state(:initial => true)
          g.add_n_states(2)
          g.connect(0, 1, :guard => "moving", :event => :start)
          g.connect(0, 2, :guard => "(moving and closed) or not(moving)", :event => :stop)
        end
      }

      it{ should be_weakly_equivalent(expected) }
    end

    context 'on a dumb cyclic glts' do
      let(:glts){
        Glts.new(s) do |g|
          g.add_state(:initial => true)
          g.add_state
          g.connect(0, 1, :guard => "moving")
          g.connect(1, 0, :guard => "closed")
        end
      }
      let(:expected){
        Glts.new(s) do |f|
          x = f.add_state(:initial => true)
        end
      }

      it{ should be_weakly_equivalent(expected) }
    end

    context 'on an empty glts' do
      let(:glts){
        Glts.new(s) do |f|
          x = f.add_state(:initial => true)
        end
      }
      let(:expected){
        glts
      }

      it{ should be_weakly_equivalent(expected) }
    end

    context 'with g1, g2, g3 as guards' do
      before{ [:g1, :g2, :g3].each{|v| s.fluent v, [], [] } }

      context 'with a superficious guard to be removed' do
        let(:glts){
          # (x) -> [g1]/a -> (y) -> [g2]/nil -> (z)
          Glts.new(s) do |f|
            x = f.add_state(:initial => true)
            y = f.add_state
            z = f.add_state
            f.connect(x, y, :guard => "g1", :event => "a")
            f.connect(y, z, :guard => "g2")
          end
        }
        let(:expected){
          # (x) -> [g1]/a -> (y)
          Glts.new(s) do |f|
            x = f.add_state(:initial => true)
            y = f.add_state
            f.connect(x, y, :guard => "g1", :event => "a")
          end
        }

        it{ should be_weakly_equivalent(expected) }
      end

      context 'with unreachable state through false guard' do
        let(:glts){
          # (x) -> [g1]/nil -> (y) -> [!g1]/a -> (z)
          Glts.new(s) do |f|
            x = f.add_state(:initial => true)
            y = f.add_state
            z = f.add_state
            f.connect(x, y, :guard => "g1")
            f.connect(y, z, :guard => "not(g1)", :event => "a")
          end
        }
        let(:expected){
          # (x) -> [false]/a -> (y)
          Glts.new(s) do |f|
            x = f.add_state(:initial => true)
            y = f.add_state
            f.connect(x, y, :guard => "false", :event => "a")
          end
        }

        it{ should be_weakly_equivalent(expected) }
      end

      context 'an unuseful guarded transition' do
        let(:glts){
          # (x) -> [g1]/nil -> (y)
          # (x) -> [g2]/a -> (y)
          Glts.new(s) do |f|
            x = f.add_state(:initial => true)
            y = f.add_state
            f.connect(x, y, :guard => "g1")
            f.connect(x, y, :guard => "g2", :event => "a")
          end
        }
        let(:expected){
          # (x) -> [g2]/a -> (y)
          Glts.new(s) do |f|
            x = f.add_state(:initial => true)
            y = f.add_state
            f.connect(x, y, :guard => "g2", :event => "a")
          end
        }

        it{ should be_weakly_equivalent(expected) }
      end

      context 'on disjoint/complete guards with a epsilon on one of them' do
        let(:glts){
          # (x) -> [g1]/a -> (y)
          # (x) -> [!g1]/nil -> (y)
          # (y) -> [g2]/b -> (z)
          Glts.new(s) do |f|
            x = f.add_state(:initial => true)
            y = f.add_state
            z = f.add_state
            f.connect(x, y, :guard => "g1", :event => "a")
            f.connect(x, y, :guard => "not(g1)")
            f.connect(y, z, :guard => "g2", :event => "b")
          end
        }
        let(:expected){
          # (x) -> [g1]/a -> (y)
          # (x) -> [!g1 & g2]/b -> (z)
          # (y) -> [g2]/b -> (z)
          Glts.new(s) do |f|
            x = f.add_state(:initial => true)
            y = f.add_state
            z = f.add_state
            f.connect(x, y, :guard => "g1", :event => "a")
            f.connect(x, z, :guard => "not(g1) and g2", :event => "b")
            f.connect(y, z, :guard => "g2", :event => "b")
          end
        }

        it{ should be_weakly_equivalent(expected) }
      end

      context 'on a guarded loop' do
        let(:glts){
          # (x) -> [g1]/a -> (y) -> [g2]/nil -> (x)
          Glts.new(s) do |f|
            x = f.add_state(:initial => true)
            y = f.add_state
            f.connect(x, y, :guard => "g1", :event => "a")
            f.connect(y, x, :guard => "g2")
          end
        }
        let(:expected){
          # (x) -> [g1]/a -> (y) -> [g1 & g2]/a -> (y)
          Glts.new(s) do |f|
            x = f.add_state(:initial => true)
            y = f.add_state
            f.connect(x, y, :guard => "g1", :event => "a")
            f.connect(y, y, :guard => "g1 and g2", :event => "a")
          end
        }

        it{ should be_weakly_equivalent(expected) }
      end

    end

  end
end