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

      def with_bdd(*bdds)
        bdds.each{|bdd| bdd.ref}
        yield(*bdds)
      ensure
        bdds.each{|bdd| bdd.deref}
      end

    end
  end
end
