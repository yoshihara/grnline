# -*- coding: utf-8 -*-

base_dir = File.join(File.dirname(__FILE__))
lib_dir = File.join(base_dir, "lib")
$LOAD_PATH.unshift(lib_dir)
require "grnline/version"

helper = Bundler::GemHelper.new(base_dir)
helper.install
def helper.version_tag
  version
end

desc "Run tests."
task :test do
  ruby("test/run-test.rb")
end

task :default => :test

