require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Ekar do

  before(:each) do
    FileUtils.rm_rf('ekar_test.tmp')
  end
  
  after(:each) do
    FileUtils.rm_rf('ekar_test.tmp')
  end
  
  describe "invoke" do
    
    it "should raise an exception if that task doesn't exist" do
      lambda {Ekar.invoke('asdlkfj')}.should raise_error(Ekar::UndefinedTask)
    end
    
  end
  
  describe "list" do
    
    it "should list all tasks" do
      Ekar.desc("A Foo Task")
      Ekar.task(:foo) do |t|
      end
      Ekar.list.should match(/ekar foo\n    A Foo Task/)
    end
    
  end

  describe "namespace" do
    
    it "should wrap a task in a namespace" do
      Ekar.namespace(:one) do
        Ekar.task(:two) do
          File.open('ekar_test.tmp', 'w') {|f| f.puts "one:two"}
        end
      end
      task = Ekar::House.get("one:two")
      task.should_not be_nil
      task.name.should == "one:two"
      task.run
      File.read('ekar_test.tmp').should match(/one:two/)
    end
    
    it "should wrap a task in multiple namespaces" do
      Ekar.namespace(:one) do
        Ekar.namespace(:two) do
          Ekar.task(:three) do
            File.open('ekar_test.tmp', 'w') {|f| f.puts "one:two:three"}
          end
        end
      end
      task = Ekar::House.get("one:two:three")
      task.should_not be_nil
      task.name.should == "one:two:three"
      task.run
      File.read('ekar_test.tmp').should match(/one:two:three/)
    end
    
  end
  
  describe "task" do
    
    it "should yield up an Ekar::Task class with the name of the task preset" do
      Ekar.task(:foo) do |t, options|
        t.should be_is_a(Ekar::Task)
        t.name.should == "foo"
      end
      Ekar::House.get(:foo).run
    end
    
  end

end
