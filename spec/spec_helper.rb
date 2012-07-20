$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gisele-analysis'

module SpecHelpers

  def session
    @session ||= Gisele::Analysis::Session.new
  end

end

RSpec.configure do |c|
  c.include SpecHelpers

  c.after(:all){ @session.close if @session }

end
