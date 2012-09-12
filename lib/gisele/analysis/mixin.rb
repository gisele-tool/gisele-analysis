require_relative 'mixin/vars_holder'
require_relative 'mixin/bdd_management'
module Gisele::Analysis
  module Mixin

    def self.new(s, *mixins)
      Object.new.tap do |o|
        o.extend(*mixins)
        (class << o; self; end).send(:define_method, :session){ s }
      end
    end
    
  end # module Mixin
end # module Gisele::Analysis
