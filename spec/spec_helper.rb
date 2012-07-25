$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gisele-analysis'

module SpecHelpers
  include Gisele::Analysis::Session::Utils

  def meeting_scheduling_sexpr
    Gisele::Language.sexpr Path.dir/"fixtures/MeetingScheduling.gis"
  end

  def session(with_vars = false)
    @session ||= begin
      s = Gisele::Analysis::Session.new
      if with_vars
        s.fluent :moving, [:start], [:stop], false
        s.fluent :closed, [:close], [:open], true
      end
      s
    end
  end

  def s
    @session_with_vars ||= session(true)
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
