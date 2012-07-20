module Gisele::Analysis
  class Glts < Stamina::Automaton

    GUARD_SYMBOL = "[guard]"

    attr_reader :session

    def initialize(session)
      @session = session
      super()
    end

    def add_state(data = {})
      data[:accepting] = true
      super
    end

    def connect(from, to, data)
      data[:symbol] ||= data[:event] || GUARD_SYMBOL
      data[:bdd]    ||= session.bdd(data[:guard] || true)
      super(from, to, data)
    end

    def to_dot
      super false, &DOT_REWRITER
    end

    DOT_REWRITER = lambda{|elm,kind|
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
          {:label     => Glts.edge_label(elm),
           :arrowsize => "0.7"}
      end
    }

  private

    def self.edge_label(e)
      event   = e[:event]
      guard   = e[:guard] && "[#{e[:guard]}]"
      [event, guard].compact.map(&:to_s).join(' / ')
    end

  end # class Glts
end # module Gisele
require_relative 'glts/eclosure'
