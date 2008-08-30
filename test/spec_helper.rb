require 'rubygems'
gem 'rspec'
require 'spec'

require File.join(File.dirname(__FILE__), "..", "lib", "ekar")

def cleanup
  Ekar::House.instance.tasks.clear
  FileUtils.rm_rf('ekar_test.tmp')
end