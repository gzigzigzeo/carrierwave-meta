# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "carrierwave-meta/version"

Gem::Specification.new do |s|
  s.name        = "carrierwave-meta"
  s.version     = Carrierwave::Meta::VERSION
  s.authors     = ["Victor Sokolov"]
  s.email       = ["gzigzigzi@gmail.com"]
  s.homepage    = "http://github.com/gzigzigzeo/carrierwave-meta"
  s.summary     = %q{}
  s.description = %q{}

  s.rubyforge_project = "carrierwave-meta"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency(%q<carrierwave>, [">= 0.5.7"])
  s.add_dependency(%q<activesupport>, [">= 3.0"])  
  s.add_dependency(%q<mime-types>)
  s.add_development_dependency(%q<rspec-rails>, ">= 2.6")
  s.add_development_dependency(%q<sqlite3-ruby>)    
  s.add_development_dependency(%q<rmagick>)
  s.add_development_dependency(%q<mini_magick>)
  s.add_development_dependency(%q<mime-types>)
end
