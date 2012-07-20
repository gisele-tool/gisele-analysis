require 'spec_helper'
describe Gisele::Analysis do

  it "should have a version number" do
    Gisele::Analysis.const_defined?(:VERSION).should be_true
  end

end
