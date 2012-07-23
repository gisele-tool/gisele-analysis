$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gisele-analysis'

module SpecHelpers
  include Gisele::Analysis::Session::Utils

  def session(with_vars = false)
    @session ||= begin
      s = Gisele::Analysis::Session.new
      if with_vars
        s.fluent :moving, [:start], [:stop]
        s.fluent :closed, [:close], [:open]
      end
      s
    end
  end

  def bddi(*args)
    session(*args).bdd_interface
  end

  def bdd(*args)
    session.bdd(*args)
  end

end

RSpec.configure do |c|
  c.include SpecHelpers

  c.after(:all){ @session.close if @session }
end
