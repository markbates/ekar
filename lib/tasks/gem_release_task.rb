module Ekar
  
  class GemReleaseTask
    
    attr_accessor :gem_spec
    
    def initialize(gem_spec, name = :release, *dependencies)
      self.gem_spec = gem_spec
      Ekar.namespace(:gem) do
        Ekar.desc "Release the #{self.gem_spec.name} gem"
        Ekar.task(name, [:install, dependencies].flatten) do |t|
          require 'rubyforge'
          begin
            ac_path = File.join(ENV["HOME"], ".rubyforge", "auto-config.yml")
            if File.exists?(ac_path)
              fixed = File.open(ac_path).read.gsub("  ~: {}\n\n", '')
              fixed.gsub!(/    !ruby\/object:Gem::Version \? \n.+\n.+\n\n/, '')
              puts "Fixing #{ac_path}..."
              File.open(ac_path, "w") {|f| f.puts fixed}
            end
            begin
              rf = RubyForge.new
              rf.configure
              rf.login
              rf.add_release(self.gem_spec.rubyforge_project, self.gem_spec.name, self.gem_spec.version, File.join("pkg", "#{self.gem_spec.name}-#{self.gem_spec.version}.gem"))
            rescue Exception => e
              if e.message.match("Invalid package_id") || e.message.match("no <package_id> configured for")
                puts "You need to create the package!"
                rf.create_package(self.gem_spec.rubyforge_project, self.gem_spec.name)
                rf.add_release(self.gem_spec.rubyforge_project, self.gem_spec.name, self.gem_spec.version, File.join("pkg", "#{self.gem_spec.name}-#{self.gem_spec.version}.gem"))
              else
                raise e
              end
            end
          rescue Exception => e
            if e.message == "You have already released this version."
              puts e
            else
              raise e
            end
          end
        end # task
      end # namespace
      
    end # initialize
    
  end # GemReleaseTask
  
end # Ekar