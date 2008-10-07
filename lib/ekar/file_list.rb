module Ekar
  
  class FileList
    
    attr_accessor :list
    
    def initialize(*paths)
      self.list = []
      [paths].flatten.each do |path|
        self.list << Dir.glob(File.join(path))
      end
      self.list.flatten!
    end
    
    def method_missing(sym, *args)
      self.list.send(sym, *args)
    end
    
    def to_a
      self.list
    end
    
    def to_ary
      self.list
    end
    
    class << self
      
      def [](*args)
        new(*args)
      end
      
    end
    
  end
  
end