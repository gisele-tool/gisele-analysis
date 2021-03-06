module Gisele::Analysis
  class Glts < Stamina::Automaton
    include Mixin::BddManagement

    attr_reader :session

    def initialize(session)
      @session = session
      super(false)
    end

    def c0
      @c0 || session.c0_from_variables
    end

    def c0=(c0)
      @guards_mode = nil
      @invariants_generated = nil
      @c0 = session.bdd(c0)
    end

    def add_state(data = {})
      data[:accepting] = true
      super.extend(State)
    end

    def connect(from, to, data = {})
      data[:symbol] ||= data[:event] || nil
      data[:guard]    = session.bdd(data[:guard] || true).ref
      super(from, to, data).extend(Edge)
    end

    def dup(glts = nil)
      glts ||= Glts.new(session){|g| g.c0 = self.c0}
      super(glts)
    end

    def end_state
      states.find{|s| s.out_edges.empty? }
    end

    ### OUTPUT ###########################################################################

    TO_DNF_OPERATORS = {:not => 'not', :or => 'or', :and => 'and'}

    def to_dot
      super(false) do |elm, kind|
        case kind
          when :automaton
            {:rankdir => "TB",
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
        buf << "  g.connect #{e.source.index}, #{e.target.index}"
        buf << ", :guard => #{e.to_dnf.inspect}" unless guard.one?
        buf << ", :event => #{event}" if event
        buf << "\n"
      end
      buf << "end\n"
      buf
    end

    def to_ast
      Compiling::Glts2Ast.call(self)
    end

    def o(name = "glts")
      tap do
        Path("#{name}.dot").write(to_dot)
        `dot -Tgif -o #{name}.gif #{name}.dot`
        Path("#{name}.dot").unlink
        puts "!!! Glts printed to #{name}.gif !!!"
      end
    end

  private

    def edge_label(e)
      event   = e[:event]
      guard   = (e[:guard] == one) ? nil : "[#{e[:guard].to_dnf(TO_DNF_OPERATORS)}]"
      [guard, event].compact.map(&:to_s).join(' / ')
    end

  end # class Glts
end # module Gisele
require_relative 'glts/state'
require_relative 'glts/edge'

require_relative 'glts/eclosure'
require_relative 'glts/tclosure'
require_relative 'glts/determinize'
require_relative 'glts/minimize'
require_relative 'glts/trim'
require_relative 'glts/equivalence'
require_relative 'glts/invariants'
require_relative 'glts/guards'
require_relative 'glts/union'
require_relative 'glts/merge'
require_relative 'glts/project'
require_relative 'glts/separate'
require_relative 'glts/intervals'
require_relative 'glts/to_yargi'
require_relative 'glts/to_graph'
