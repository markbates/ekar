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
        tasks << "ekar #{name}\n    #{task.description}" if task.description
      end
      tasks.join("\n\n")
    end
  
    private
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
