require File.expand_path("../lib/iptc/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "iptc"
  s.version     = IPTC::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Pierre Baillet", "Jens Kraemer"]
  s.email       = ["jk@jkraemer.net"]
  s.homepage    = "http://github.com/jkraemer/ruby-iptc"
  s.summary     = "Pure ruby IPTC metadata reader"
  s.description = "Original code from http://raa.ruby-lang.org/project/jpeg-jfif-iptc/, gemified and updated by Jens Kraemer"

  s.required_rubygems_version = ">= 1.3.6"

  # lol - required for validation
  s.rubyforge_project         = "ruby-iptc"

  # If you have other dependencies, add them here
  # s.add_dependency "another", "~> 1.2"

  # If you need to check in files that aren't .rb files, add them here
  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path = 'lib'

  # If you need an executable, add it here
  # s.executables = ["newgem"]

  # If you have C extensions, uncomment this line
  # s.extensions = "ext/extconf.rb"
end