module Ekar
  
  class GemPackageTask < Ekar::Task
    
    attr_accessor :gem_spec
    # Directory used to store the package files (default is 'pkg').
    attr_accessor :package_dir

    # True if a gzipped tar file (tgz) should be produced (default is false).
    attr_accessor :need_tar

    # True if a gzipped tar file (tar.gz) should be produced (default is false).
    attr_accessor :need_tar_gz

    # True if a bzip2'd tar file (tar.bz2) should be produced (default is false).
    attr_accessor :need_tar_bz2

    # True if a zip file should be produced (default is false)
    attr_accessor :need_zip

    # List of files to be included in the package.
    attr_accessor :package_files

    # Tar command for gzipped or bzip2ed archives.  The default is 'tar'.
    attr_accessor :tar_command

    # Zip command for zipped archives.  The default is 'zip'.
    attr_accessor :zip_command
    
    def initialize(gem_spec, name = :package, *dependencies, &block)
      self.gem_spec = gem_spec
      self.package_files = []
      self.package_dir = 'pkg'
      self.need_tar = false
      self.need_tar_gz = false
      self.need_tar_bz2 = false
      self.need_zip = false
      self.tar_command = 'tar'
      self.zip_command = 'zip'
      
      super(name, *dependencies, &block)
      block.call(self)
      
      Ekar.desc "Clean up the #{self.gem_spec.name} gem files."
      Ekar.task(:clean) do
        FileUtils.rm_rf(package_dir)
      end
      
      Ekar.desc "Package the #{self.gem_spec.name} gem."
      Ekar.task(name, :clean) do |t|
        Gem::Builder.new(gem_spec).build
        FileUtils.mv gem_file, "#{package_dir}/#{gem_file}"
      end
    end
    
    def package_name
      self.gem_spec.version ? "#{self.gem_spec.name}-#{self.gem_spec.version}" : self.gem_spec.name
    end
      
    def package_dir_path
      "#{package_dir}/#{package_name}"
    end

    def tgz_file
      "#{package_name}.tgz"
    end

    def tar_gz_file
      "#{package_name}.tar.gz"
    end

    def tar_bz2_file
      "#{package_name}.tar.bz2"
    end

    def zip_file
      "#{package_name}.zip"
    end
    
    def gem_file
      if self.gem_spec.platform == Gem::Platform::RUBY
        "#{package_name}.gem"
      else
        "#{package_name}-#{self.gem_spec.platform}.gem"
      end
    end
    
  end
  
end