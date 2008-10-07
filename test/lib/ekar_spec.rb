require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Ekar do

  before(:each) do
    cleanup
  end
  
  after(:each) do
    cleanup
  end
  
  describe "invoke" do
    
    it "should raise an exception if that task doesn't exist" do
      lambda {Ekar.invoke('asdlkfj')}.should raise_error(Ekar::UndefinedTask)
    end
    
  end
  
  describe "alias" do
    
    it "should alias off a task to a new name" do
      Ekar.desc "A Foo Task"
      Ekar.task(:foo) do
        File.open('ekar_test.tmp', 'w') {|f| f.puts '12345'}
      end
      Ekar.alias(:foo_bar, :foo)
      Ekar.list.should match(/ekar foo\n    A Foo Task/)
      Ekar.list.should match(/ekar foo_bar\n    A Foo Task/)
      Ekar.invoke(:foo_bar)
      File.read('ekar_test.tmp').should match(/12345/)
      
      Ekar.desc "A FooBar Task"
      Ekar.alias(:foo_bar, :foo)
      Ekar.list.should match(/ekar foo_bar\n    A FooBar Task/)
    end
    
    it "should raise an exception if the task doesn't exist" do
      lambda {Ekar.alias(:foo_bar, :fubar)}.should raise_error(Ekar::UndefinedTask)
    end
    
  end
  
  describe "chain" do
    
    it "should create a 'chain' of tasks with a given name." do
      Ekar.task(:first_name) do
        File.open('ekar_test.tmp', 'a') {|f| f.puts 'Mark'}
      end

      Ekar.task(:last_name, :first_name) do
        File.open('ekar_test.tmp', 'a') {|f| f.puts 'Bates'}
      end
      Ekar.desc "Say the full name"
      Ekar.chain(:full_name, :last_name, :first_name)
      Ekar.run(:full_name)
      Ekar.list.should match(/ekar full_name\n    Say the full name/)
      File.read('ekar_test.tmp').should match(/Mark\nBates/)
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
    
    it 'should properly resolve namespaced dependencies' do
      Ekar.task(:one) do
        File.open('ekar_test.tmp', 'w') {|f| f.puts "one"}
      end
      Ekar.namespace(:two) do
        Ekar.task(:three, :one) do
          File.open('ekar_test.tmp', 'a') {|f| f.puts "three"}
        end
      end
      Ekar.run('two:three')
      File.read('ekar_test.tmp').should == "one\nthree\n"
      
      cleanup
      
      Ekar.namespace(:two) do
        Ekar.task(:one) do
          File.open('ekar_test.tmp', 'w') {|f| f.puts "one"}
        end
        Ekar.task(:three, :one) do
          File.open('ekar_test.tmp', 'a') {|f| f.puts "three"}
        end
      end
      
      cleanup
      
      Ekar.namespace(:two) do
        Ekar.task(:one) do
          File.open('ekar_test.tmp', 'w') {|f| f.puts "one"}
        end
        Ekar.task(:three, 'two:one') do
          File.open('ekar_test.tmp', 'a') {|f| f.puts "three"}
        end
      end
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
