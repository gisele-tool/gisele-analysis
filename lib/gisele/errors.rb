module Gisele
  class Error < StandardError; end unless defined?(Gisele::Error)
  class NoSuchVariableError < Gisele::Error; end
end
