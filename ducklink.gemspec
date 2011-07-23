# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ducklink/version"

Gem::Specification.new do |s|
  s.name        = "ducklink"
  s.version     = Ducklink::VERSION
  s.authors     = ["Henry Garner"]
  s.email       = ["henry.garner@mac.com"]
  s.homepage    = ""
  s.summary     = %q{Decorates URLs according to a format specification}
  s.description = %q{}

  s.rubyforge_project = "ducklink"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
