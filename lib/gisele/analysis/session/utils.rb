module Gisele::Analysis
  class Session
    module Utils

      attr_reader :session

      def cudd_manager
        session.cudd_manager
      end

      def bdd_interface
        session.bdd_interface
      end

      def one
        bdd_interface.one
      end

      def zero
        bdd_interface.zero
      end

    end
  end
end