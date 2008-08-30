module Ekar
  class Command
    
    attr_accessor :options
    
    def initialize(params)
      self.options = [params].flatten
    end
    
    def run
      task = Ekar::House.get(self.options.first)
      if task
        task.run(self.options)
      end
    end
    
  end
end