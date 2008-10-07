module Ekar
  
  class RSpecTask < Ekar::Task
    
    attr_accessor :spec_opts
    attr_accessor :spec_files
    
    def initialize(name, *dependencies, &block)
      super(name, *dependencies, &block)
      self.spec_opts = []
      self.spec_files = ''
      block.call(self)
      Ekar.task(name, *dependencies) do
        system "spec #{self.spec_opts.join(' ')} #{self.spec_files.join(' ')}"
      end
    end
    
  end
  
end