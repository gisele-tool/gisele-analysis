$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gisele-analysis'

module SpecHelpers

  def session
    @session ||= Gisele::Analysis::Session.new
  end

  def bddi
    session.cudd_manager.interface(:BDD)
  end

end

RSpec.configure do |c|
  c.include SpecHelpers

  c.after(:all){ @session.close if @session }
end
