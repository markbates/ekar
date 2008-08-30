module Ekar
  class Task
    
    attr_accessor :name
    attr_accessor :code_body
    attr_accessor :dependencies
    attr_accessor :description
    
    def initialize(name, *dependencies, &block)
      self.name = name
      self.dependencies = dependencies
      self.code_body = block
    end
    
    def run(options = [])
      unless self.code_body.nil?
        self.code_body.call(self, options)
        return
      end
      raise Ekar::NoCodeDefinitionError.new(name)
    end
    
  end
end