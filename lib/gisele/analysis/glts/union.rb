module Gisele::Analysis
  class Glts

    class Union

      def initialize(session)
        @session = session
      end
      attr_reader :session

      def call(operands)
        Glts.new(session) do |to|
          init_state = to.add_state(:initial => true)
          operands.each_with_index do |from,index|
            add_glts(from, to, init_state, :"wf#{index}")
          end
        end
      end

    private

      def add_glts(from, to, init_state, origin)
        from.dup(to) do |s, t|
          if s.initial?
            t.initial!(false)
            to.connect(init_state, t, :guard => from.c0)
          end
          t[:origin] = origin
        end
      end

    end

    def union(other)
      Union.new(session).call([self, other])
    end
    alias :+ :union

  end # class Glts
end # module Gisele::Analysis
