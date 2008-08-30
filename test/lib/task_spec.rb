require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Ekar::Task do

  before(:each) do
    FileUtils.rm_rf('ekar_test.tmp')
  end
  
  after(:each) do
    FileUtils.rm_rf('ekar_test.tmp')
  end

  it "should raise an Ekar::NoCodeDefinitionError exception if there is no code body" do
    lambda{Ekar::Task.new(:foo).run}.should raise_error(Ekar::NoCodeDefinitionError)
  end
  
  it "should run the code body given to it" do
    t = Ekar::Task.new(:foo)
    t.code_body = lambda {
      File.open('ekar_test.tmp', 'w') {|f| f.puts '12345'}
    }
    t.run
    File.read('ekar_test.tmp').should match(/12345/)
  end

end
