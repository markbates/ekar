require 'rake'
require 'rake/gempackagetask'
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'
require 'find'
require 'rubyforge'
require 'rubygems'
require 'rubygems/gem_runner'
require 'spec'
require 'spec/rake/spectask'

spec = Gem::Specification.new do |s|
  s.name = "ekar"
  s.version = "0.0.1"
  s.summary = "ekar"
  s.description = "ekar was developed by: markbates"
  s.author = "markbates"
  #s.email = ""
  #s.homepage = ""

  s.test_files = FileList['test/**/*']

  s.files = FileList['lib/**/*.*', 'README', 'doc/**/*.*', 'bin/**/*.*']
  s.require_paths << 'lib'

  s.bindir = "bin"
  s.executables << "ekar"
  #s.default_executable = ""
  #s.add_dependency("", "")
  #s.add_dependency("", "")
  #s.extensions << ""
  s.extra_rdoc_files = ["README"]
  s.has_rdoc = true
  #s.platform = "Gem::Platform::Ruby"
  #s.required_ruby_version = ">= 1.8.6"
  #s.requirements << "An ice cold beer."
  #s.requirements << "Some free time!"
  s.rubyforge_project = "ekar"
end

# rake package
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = false
  pkg.need_tar = false
  rm_f FileList['pkg/**/*.*']
end

# rake
desc 'Run specifications'
Spec::Rake::SpecTask.new(:default) do |t|
  opts = File.join(File.dirname(__FILE__), "test", 'spec.opts')
  t.spec_opts << '--options' << opts if File.exists?(opts)
  t.spec_files = Dir.glob('test/**/*_spec.rb')
end

desc "Install the gem"
task :install => :package do |t|
  puts `sudo gem install pkg/#{spec.name}-#{spec.version}.gem`
end

desc "Release the gem"
task :release => :install do |t|
  begin
    rf = RubyForge.new
    rf.login
    begin
      rf.add_release(spec.rubyforge_project, spec.name, spec.version, File.join("pkg", "#{spec.name}-#{spec.version}.gem"))
    rescue Exception => e
      if e.message.match("Invalid package_id") || e.message.match("no <package_id> configured for")
        puts "You need to create the package!"
        rf.create_package(spec.rubyforge_project, spec.name)
        rf.add_release(spec.rubyforge_project, spec.name, spec.version, File.join("pkg", "#{spec.name}-#{spec.version}.gem"))
      else
        raise e
      end
    end
  rescue Exception => e
    puts e
  end
end


Rake::RDocTask.new do |rd|
  rd.main = "README"
  files = Dir.glob("**/*.rb")
  files = files.collect {|f| f unless f.match("test/") || f.match("doc/") }.compact
  files << "README"
  rd.rdoc_files = files
  rd.rdoc_dir = "doc"
  rd.options << "--line-numbers"
  rd.options << "--inline-source"
  rd.title = "ekar"
end
