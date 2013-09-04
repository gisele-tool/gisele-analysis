module Gisele::Analysis
  class Glts
    class ToGraph

      # No event, a non-trivial guard
      GUARD_EDGE = lambda{|e|
        return nil unless e[:event].nil?

        # Returns the guard as DNF
        e[:guard] && e[:guard].to_dnf
      }

      # Only a start event, no guard.
      # Returns task name.
      START_EVENT_EDGE = lambda{|e|
        # no guard
        return nil unless e[:guard].true?

        # start event
        return nil unless e[:event] =~ /^(.*?):(.*?)$/
        return nil unless $2 == "start"

        # all right, return task name
        $1
      }

      # Only an end event, no guard.
      # Returns task name.
      END_EVENT_EDGE = lambda{|e|
        # no guard
        return nil unless e[:guard].true?

        # end event
        return nil unless e[:event] =~ /^(.*?):(.*?)$/
        return nil unless $2 == "end"

        # all right, return task name
        $1
      }

      # Task start state: only one output edge with a start event and no guard. 
      # Returns task name.
      TASK_START_STATE = lambda{|s|
        # one out edge only
        return nil unless s.out_edges.size == 1

        # delegate
        START_EVENT_EDGE.call(s.out_edges.first)
      }

      # Task middle state: one input with start event and no guard,
      #                    one output edge with end event and no guard
      TASK_MIDDLE_STATE = lambda{|s|
        # one in edge, one out edge
        return nil unless s.out_edges.size == 1 and s.in_edges.size == 1
        ein, eout = s.in_edges.first, s.out_edges.first

        # extract task names
        in_task  = START_EVENT_EDGE.call(ein)
        out_task = END_EVENT_EDGE.call(eout)

        # same task, not nil
        return nil unless in_task && (in_task == out_task)

        in_task
      }

      # Process init state: no input edge and task start state.
      # Returns task name.
      PROCESS_INIT_STATE = lambda{|s|
        # no input edge
        return nil unless s.in_edges.empty?

        # must be a task start
        return nil unless task = TASK_START_STATE.call(s)
        
        task
      }

      # Process end state: no output edge and all incoming same end event
      PROCESS_END_STATE = lambda{|s|
        # no output edge
        return nil unless s.out_edges.empty?

        # no input guard
        tasks = s.in_edges.map(&END_EVENT_EDGE).uniq
        return nil unless tasks.size == 1

        # all right, return task name
        tasks.first
      }

      DECISION_STATE = lambda{|s|
        # at least one out edge
        return false unless s.out_edges.size >= 1

        # all nil events
        return false unless s.out_edges.all?{|e| e[:event].nil? }

        # all right
        true
      }

      IF_THEN_ELSE_STATE = lambda{|s|
        # must be a decision state
        return false unless DECISION_STATE === s

        # 2 out edges only
        return false unless s.out_edges.size == 2

        # one is negation of the other
        t_edge, e_edge = s.out_edges
        return false unless t_edge[:guard] = e_edge[:guard].not

        # all right, return both guards
        [ t_edge[:guard], e_edge[:guard] ]
      }

      STATE_KINDS = [
        IF_THEN_ELSE_STATE,
        DECISION_STATE,
        PROCESS_INIT_STATE,
        PROCESS_END_STATE,
        TASK_MIDDLE_STATE,
        TASK_START_STATE
      ]

      def initialize(session)
        @session = session
      end
      attr_reader :session

      def call(glts)
        # convert to a Yargi graph now
        graph = glts.to_yargi

        # Mark all guarded edges by default
        graph.edges(GUARD_EDGE).add_marks{|e|
          { label: GUARD_EDGE[e] }
        }

        # Convert task middle states as task boxes
        graph.vertices(TASK_MIDDLE_STATE).add_marks{|v|
          { ast: "task_call_st",
            shape: "box",
            label: TASK_MIDDLE_STATE[v] }
        }

        # Convert decisions as diamonds
        graph.vertices(DECISION_STATE).add_marks{|v|
          { ast: "case_st",
            shape: "diamond" }
        }

        # Convert if/then/else as better diamonds
        graph.vertices(IF_THEN_ELSE_STATE).add_marks{|v|
          t_edge,  e_edge  = v.out_edges
          t_guard, e_guard = v.out_edges.map{|e| e[:guard].to_dnf }
          if t_guard.length > e_guard.length
            t_edge,  e_edge  = e_edge, t_edge
            t_guard, e_guard = e_guard, t_guard
          end
          t_edge[:label] = "yes"
          e_edge[:label] = "no"
          { ast: "case_st", shape: "diamond", label: t_guard }
        }

        # Convert process init states
        graph.vertices(Yargi::Predicate::NONE | PROCESS_INIT_STATE | PROCESS_END_STATE).add_marks{|v|
          { ast: "task_def",
            shape: "circle",
            style: "filled",
            fillcolor: "black",
            fixed: true,
            width: 0.1,
            label: "" }
        }

        # Set all states as connectors
        graph.vertices(->(v){ v[:ast].nil? }).add_marks{|v|
          { shape: "square",
            style: "filled",
            fillcolor: "black",
            fixed: true,
            width: 0.01,
            label: "" }
        }

        clean(graph)
      end

      def clean(graph)
        to_remove = lambda{|v|
          (v[:shape] == "square") && (v.out_edges.size == 1) && v.out_edges.first[:label].nil?
        }
        found = false
        graph.vertices(to_remove){|v|
          target = v.out_edges.first.target
          graph.reconnect(v.in_edges, nil, target)
          graph.remove_vertex(v)
          found = true
        }
        found ? clean(graph) : graph
      end

    end # class ToGraph

    def to_graph
      ToGraph.new(session).call(self)
    end

  end # class Glts
end # module Gisele::Analysis
