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
require "gisele/analysis/mixin"
require "gisele/analysis/session"
require "gisele/analysis/variable"
require "gisele/analysis/glts"
require "gisele/analysis/ghmsc"
require "gisele/analysis/compiling"
