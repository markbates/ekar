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
  
  it "should run a task" do
    Ekar.task(:foo) do
      File.open('ekar_test.tmp', 'w') {|f| f.puts '12345'}
    end
    Ekar.invoke(:foo)
    File.read('ekar_test.tmp').should match(/12345/)
  end
  
  it "should run a task and it's dependencies" do
    Ekar.task(:first_name) do
      File.open('ekar_test.tmp', 'a') {|f| f.puts 'Mark'}
    end
    
    Ekar.task(:last_name, :first_name) do
      File.open('ekar_test.tmp', 'a') {|f| f.puts 'Bates'}
    end
    
    Ekar.invoke(:last_name)
    File.read('ekar_test.tmp').should match(/Mark\nBates/)
  end

end
