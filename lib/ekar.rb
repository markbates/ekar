require 'fileutils'
require 'singleton'
require 'optparse'
require 'optparse/time'
require 'ostruct'
Dir.glob(File.join(File.dirname(__FILE__), "ekar", "**/*.rb")).each do |f|
  require f
end

module Ekar
  
  {:RSpecTask => 'r_spec_task.rb', 
   :GemPackageTask => 'gem_package_task.rb', 
   :GemSpecTask => 'gem_spec_task.rb',
   :GemReleaseTask => 'gem_release_task.rb'}.each do |k, v|
    autoload k, File.join(File.dirname(__FILE__), 'tasks', v)
  end
  
  class << self
  
    def namespace(space)
      current_namespaces << space.to_s
      yield
      current_namespaces.pop
    end
  
    def task(name, *dependencies, &block)
      task = Ekar::Task.new(fully_qualified_name(name), [dependencies].flatten.collect{|d| d.to_s.match(/:/) ? d : fully_qualified_name(d)}, &block)
      handle_task_description(task)
      Ekar::House.set(fully_qualified_name(name), task)
    end
    
    def desc(description)
      @_ekar_description = description
    end
    
    def list
      tasks = []
      Ekar::House.instance.tasks.each do |name, task|
        if task.description
          tasks << "ekar #{name}\n    #{task.description}"
        else
          tasks << "ekar #{name}"
        end
      end
      tasks.join("\n")
    end
    
    def invoke(name, options = [])
      task = Ekar::House.get(name)
      if task
        task.run(options)
      else
        a = name.to_s.split(':')
        if a.size == 1
          handle_unknown_task(name)
        else
          n = a.pop # get the name of the task
          a.pop # remove one level
          a << n
          invoke(a.join(':'), options)
        end
      end
    end
    
    def alias(new_name, old_name)
      task = Ekar::House.get(old_name)
      if task
        task = task.dup
        handle_task_description(task)
        Ekar::House.set(new_name, task)
      else
        handle_unknown_task(old_name)
      end
    end
    
    def chain(name, *tasks)
      Ekar.task(name, *tasks) {}
    end
    
    alias_method :run, :invoke
  
    private
    def handle_task_description(task)
      if @_ekar_description
        task.description = @_ekar_description
        @_ekar_description = nil
      end
    end
    
    def handle_unknown_task(name)
      if Ekar::Options[:raise_error_on_undefined_task]
        raise Ekar::UndefinedTask.new(name)
      else
        puts "Task: '#{name}' does not exist!"
      end
    end
    
    def fully_qualified_name(name)
      names = current_namespaces.dup
      names << name
      name = names.join(':') 
    end
    
    def current_namespaces
      @current_namespaces ||= []
    end
    
  end
  
end
