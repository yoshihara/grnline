# -*- coding: utf-8; mode: ruby -*-

base_dir = File.dirname(__FILE__)
$LOAD_PATH.unshift(File.expand_path("lib", base_dir))

require "grnline/version"
version = GrnLine::VERSION.dup

readme_path = File.join(base_dir, "README.md")
entries = File.read(readme_path).split(/^##\s(.*)$/)
entry = lambda do |entry_title|
  entries[entries.index(entry_title) + 1]
end
clean_white_space = lambda do |entry|
  entry.gsub(/(\A\n+|\n+\z)/, '') + "\n"
end

description = clean_white_space.call(entry.call("Description"))
summary, description = description.split(/\n\n+/, 2)

Gem::Specification.new do |spec|
  spec.name          = "grnline"
  spec.version       = version
  spec.authors       = ["Haruka Yoshihara"]
  spec.email         = ["yshr04hrk@gmail.com"]
  spec.summary       = summary
  spec.description   = description
  spec.license       = "MIT"

  spec.files = ["README.md", "LICENSE.txt"]
  spec.files += ["Rakefile", "Gemfile", "grnline.gemspec"]
  spec.files += Dir.glob("lib/**/*.rb")
#  spec.files += Dir.glob("doc/text/*.*")
#  spec.test_files = Dir.glob("test/**/*.rb")
  Dir.chdir("bin") do
    spec.executables = Dir.glob("*")
  end
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency("json")
  spec.add_development_dependency("packnga")
  spec.add_development_dependency("bundler")
  spec.add_development_dependency("rake")
  spec.add_development_dependency("test-unit")
  spec.add_development_dependency("test-unit-notify")
  spec.add_development_dependency("redcarpet")
end
