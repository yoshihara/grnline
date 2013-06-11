#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

$VERBOSE = true

base_dir = File.expand_path(File.join(File.dirname(__FILE__), ".."))
lib_dir = File.join(base_dir, "lib")
test_dir = File.join(base_dir, "test")

require "test-unit"
require "test/unit/rr"
require "test/unit/notify"

$LOAD_PATH.unshift(lib_dir)
$LOAD_PATH.unshift(base_dir)

$LOAD_PATH.unshift(test_dir)

Dir.glob("#{base_dir}/test/**/test{_,-}*.rb") do |file|
  require file.gsub(/\.rb$/, "")
end

ENV["TEST_UNIT_MAX_DIFF_TARGET_STRING_SIZE"] ||= "5000"

exit(Test::Unit::AutoRunner.run)
