require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Ekar::Command do

  before(:each) do
    FileUtils.rm_rf('ekar_test.tmp')
  end
  
  after(:each) do
    FileUtils.rm_rf('ekar_test.tmp')
  end
  
  it "should run a task" do
    Ekar.task(:foo) do
      File.open('ekar_test.tmp', 'w') {|f| f.puts '12345'}
    end
    com = Ekar::Command.new("foo")
    com.run
    File.read('ekar_test.tmp').should match(/12345/)
  end
  
end