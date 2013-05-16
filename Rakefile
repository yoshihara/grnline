# -*- coding: utf-8 -*-
require 'rubygems/package_task'
require 'bundler/gem_helper'

base_dir = File.join(File.dirname(__FILE__))
lib_dir = File.join(base_dir, "lib")
$LOAD_PATH.unshift(lib_dir)
require "grnline/version"

helper = Bundler::GemHelper.new(base_dir)
helper.install
def helper.version_tag
  version
end

