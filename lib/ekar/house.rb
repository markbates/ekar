module Ekar
  class House
    include Singleton
    
    attr_accessor :tasks
    
    def initialize
      self.tasks = {}
    end
    
    class << self
      
      def get(name)
        Ekar::House.instance.tasks[name.to_s.downcase]
      end
      
      def set(name, task)
        Ekar::House.instance.tasks[name.to_s.downcase] = task
      end
      
    end
    
  end
end