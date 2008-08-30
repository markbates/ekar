module Ekar
  class NoCodeDefinitionError < StandardError
    
    def initialize(name)
      super("There was no code definition set for task: #{name}")
    end
    
  end
end