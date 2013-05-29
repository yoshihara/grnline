# -*- coding: utf-8 -*-

require "packnga"

base_dir = File.join(File.dirname(__FILE__))
lib_dir = File.join(base_dir, "lib")
$LOAD_PATH.unshift(lib_dir)
require "grnline/version"

helper = Bundler::GemHelper.new(base_dir)
helper.install
def helper.version_tag
  version
end

spec = helper.gemspec

Packnga::DocumentTask.new(spec) do
end

Packnga::ReleaseTask.new(spec) do
end

desc "Run tests."
task :test do
  ruby("test/run-test.rb")
end

task :default => :test

