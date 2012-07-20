module Gisele
  module Analysis

    def self.session
      s = Session.new
      yield(s)
    ensure
      s.close
    end

  end
end
require "gisele/analysis/variable"
require "gisele/analysis/fluent"
require "gisele/analysis/trackvar"
require "gisele/analysis/session"
require "gisele/analysis/glts"
require "gisele/analysis/boolexpr2bdd"
