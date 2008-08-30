module Ekar
  class Options
    include Singleton
    
    attr_accessor :options
    
    def initialize
      self.options = {:search_for_ekar_files => false}
    end
    
    class << self
      
      def [](key)
        Ekar::Options.instance.options[key.to_sym]
      end
      
      def []=(key, value)
        Ekar::Options.instance.options[key.to_sym] = value
      end
      
    end
    
  end
end