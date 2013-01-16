module Gisele::Analysis
  class Glts
    module Edge

      def event
        self[:event]
      end

      def task_name
        event.to_s[/^(.*?):/, 1]
      end

      def evented?
        not(event.nil?)
      end

      def start_event?
        event.to_s =~ /:start/
      end

      def end_event?
        event.to_s =~ /:end/
      end

      def guard
        self[:guard]
      end

      def to_dnf
        guard.to_dnf(Glts::TO_DNF_OPERATORS)
      end

      def to_bool_expr
        Gisele.ast(Gisele.parse(to_dnf, root: :bool_expr))
      end

      def guarded?
        not(guard.nil? or guard == automaton.one)
      end

    end # module Edge
  end # class Glts
end # module Gisele::Analysis
