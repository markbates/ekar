module Ekar
  class Task
    
    attr_accessor :name
    attr_accessor :code_body
    attr_accessor :dependencies
    attr_accessor :description
    attr_accessor :options
    attr_accessor :maximum_runs
    attr_accessor :run_count
    
    def initialize(name, *dependencies, &block)
      self.name = name
      self.dependencies = dependencies
      self.code_body = block
      self.maximum_runs = 1
      self.run_count = 0
    end
    
    def run(options = [])
      self.dependencies.each do |dep|
        Ekar.invoke(dep, options)
      end
      if self.maximum_runs.nil? || self.maximum_runs > self.run_count
        unless self.code_body.nil?
          self.options = options
          self.code_body.call(self)
          self.run_count += 1
          return
        end
        raise Ekar::NoCodeDefinitionError.new(name)
      end
    end
    
  end
end