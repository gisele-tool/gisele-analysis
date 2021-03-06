module Gisele::Analysis
  class Variable
    include Mixin::BddManagement

    attr_reader :session
    attr_reader :name
    attr_reader :initially
    attr_reader :bdd

    def initialize(session, name, initially)
      @session = session
      @name = name
      @initially = initially
    end

    def install(cudd_manager)
      @bdd = cudd_manager.interface(:BDD).new_var(self)
    end

    def to_dnf
      name.to_s
    end

  end # class Variable
end # module Gisele
require_relative "variable/fluent"
require_relative "variable/trackvar"
