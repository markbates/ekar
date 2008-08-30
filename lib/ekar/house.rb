module Ekar
  class House
    include Singleton
    
    attr_accessor :tasks
    attr_accessor :descriptions
    
    def initialize
      self.tasks = {}
      self.descriptions = {}
    end
    
    class << self
      
      def get(name)
        Ekar::House.instance.tasks[name.to_s.downcase]
      end
      
      def set(name, task)
        Ekar::House.instance.tasks[name.to_s.downcase] = task
      end
      
      def get_desc(name)
        Ekar::House.instance.descriptions[name.to_s.downcase]
      end
      
      def set_desc(name, task)
        Ekar::House.instance.descriptions[name.to_s.downcase] = task
      end
      
    end
    
  end
end