require 'fileutils'
require 'singleton'
require 'optparse'
require 'optparse/time'
require 'ostruct'
Dir.glob(File.join(File.dirname(__FILE__), "ekar", "**/*.rb")).each do |f|
  require f
end

module Ekar
  
  class << self
  
    def namespace(space)
      current_namespaces << space.to_s
      yield
      current_namespaces.pop
    end
  
    def task(name, *dependencies, &block)
      task = Ekar::Task.new(fully_qualified_name(name), *dependencies, &block)
      if @_ekar_description
        task.description = @_ekar_description
        @_ekar_description = nil
      end
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
        handle_unknown_task(name)
      end
    end
    
    def alias(new_name, old_name)
      task = Ekar::House.get(old_name)
      if task
        task = task.dup
        if @_ekar_description
          task.description = @_ekar_description
          @_ekar_description = nil
        end
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
