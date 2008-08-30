require 'fileutils'
require 'singleton'
Dir.glob(File.join(File.dirname(__FILE__), "ekar", "**/*.rb")).each do |f|
  require f
end

module Ekar
  
  class << self
  
    def namespace(space)
      current_namespaces << space.to_s
      yield
      current_namespaces.pop
    end
  
    def task(name, *dependencies, &block)
      names = current_namespaces.dup
      names << name
      name = names.join(':')
      Ekar::House.set(name, Ekar::Task.new(name, *dependencies, &block))
    end
  
    private
    def current_namespaces
      @current_namespaces ||= []
    end
    
  end
  
end
