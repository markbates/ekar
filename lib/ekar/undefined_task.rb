module Ekar
  class UndefinedTask < StandardError
    
    def initialize(name)
      super("Task: '#{name}' does not exist!")
    end
    
  end
end