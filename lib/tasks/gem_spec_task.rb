module Ekar
  
  class GemSpecTask
    
    attr_accessor :gem_spec
    
    def initialize
      self.gem_spec = Gem::Specification.new do |s|
        yield s
      end
      Ekar.namespace(:gem) do
        Ekar::GemPackageTask.new(self.gem_spec) {}
        
        Ekar.desc "Package and install the #{self.gem_spec.name} gem."
        Ekar.task(:install, :package) do
          sudo = ENV['SUDOLESS'] == 'true' || RUBY_PLATFORM =~ /win32|cygwin/ ? '' : 'sudo'
          system "#{sudo} gem install #{File.join("pkg", self.gem_spec.name)}-#{self.gem_spec.version}.gem --no-update-sources"
        end
      end
      Ekar.alias(:install, 'gem:install')
    end
    
    def method_missing(name, *args)
      self.gem_spec.send(name, *args)
    end
    
  end
  
end