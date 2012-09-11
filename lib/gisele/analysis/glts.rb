module Gisele::Analysis
  class Glts < Stamina::Automaton
    include Session::Utils

    attr_reader :session

    def initialize(session)
      @session = session
      super(false)
    end

    def c0
      with_bdd session.c0 do |s_c0|
        (@c0 || one) & s_c0
      end
    end

    def c0=(c0)
      @c0 = session.bdd(c0)
    end

    def add_state(data = {})
      data[:accepting] = true
      super
    end

    def connect(from, to, data)
      data[:symbol] ||= data[:event] || nil
      data[:bdd]    ||= session.bdd(data[:guard] || true).ref
      super(from, to, data)
    end

    def dup(glts = Glts.new(session))
      super(glts)
    end

    ### OUTPUT ###########################################################################

    def to_dot
      super(false) do |elm, kind|
        case kind
          when :automaton
            {:rankdir => "LR",
             :margin  => "0",
             :pack    => "true",
             :ranksep => "0"}
          when :state
            {:shape     => "circle",
             :style     => "filled",
             :color     => "black",
             :fillcolor => (elm.initial? ? "green" : "white"),
             :fixedsize => "true",
             :height    => "0.6",
             :width     => "0.6"}
          when :edge
            {:label     => edge_label(elm),
             :arrowsize => "0.7"}
        end
      end
    end

    def to_ruby_literal
      buf = ""
      buf << "Glts.new(session) do |g|\n"
      buf << "  g.add_state :initial => true\n"
      buf << "  g.add_n_states #{state_count - 1}\n"
      each_edge do |e|
        s, t = e.source.index, e.target.index
        event, guard = e[:event], e[:guard]
        event = event.inspect if event
        guard = (guard.nil? or guard=="true") ? nil : guard.inspect
        buf << "  g.connect #{e.source.index}, #{e.target.index}"
        buf << ", :event => #{event}" if event
        buf << ", :guard => #{guard}" if guard
        buf << "\n"
      end
      buf << "end\n"
      buf
    end

    def to_relation
      states = Relation self.states.map{|s|
        {:index => s.index, :initial => s.initial?}
      }
      edges = Relation self.edges.map{|e|
        {:index => e.index, :from => e.source.index, :to => e.target.index,
         :event => e[:event], :guard => e[:guard]}
      }
      Relation(:states => states, :edges => edges)
    end

  private

    def edge_label(e)
      event   = e[:event]
      guard   = e[:guard] && "[#{e[:guard]}]"
      [guard, event].compact.map(&:to_s).join(' / ')
    end

  end # class Glts
end # module Gisele
require_relative 'glts/eclosure'
require_relative 'glts/determinize'
require_relative 'glts/equivalence'
require_relative 'glts/invariants'
require_relative 'glts/guards'
require_relative 'glts/union'
