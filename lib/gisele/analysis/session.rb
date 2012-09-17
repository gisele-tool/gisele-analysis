module Gisele::Analysis
  class Session
    include Mixin::VarsHolder
    include Mixin::BddManagement

    def initialize
      @cudd_manager = Cudd.manager
    end
    attr_reader :cudd_manager

    def close
      @cudd_manager.close if @cudd_manager
    ensure
      @cudd_manager = nil
    end

    def session
      self
    end

    ### gHMSC MANAGEMENT #################################################################

    def ghmscs
      @ghmscs ||= []
    end

    def ghmsc(&bl)
      Ghmsc.new(self, &bl).tap do |g|
        ghmscs << g
      end
    end

    def main_ghmsc
      ghmscs.first
    end

    ### GLTS MANAGEMENT ##################################################################

    def glts(&bl)
      Glts.new(self, &bl)
    end

  end # class Session
end # module Gisele
