# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "madrox-cluster/version"

Gem::Specification.new do |s|
  s.name        = "madrox-cluster"
  s.version     = Madrox::VERSION
  s.authors     = ["Iuri Matias"]
  s.email       = ["iuri.matias@gmail.com"]
  s.homepage    = "https://github.com/iurimatias/madrox-cluster"
  s.summary     = %q{Straightforward distributed computing in ruby}
  s.description = %q{Easily distribute any code in multiple servers}

  s.rubyforge_project = "madrox-cluster"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "pry"

  s.add_runtime_dependency 'ruby_parser'
  s.add_runtime_dependency 'file-tail' 
  s.add_runtime_dependency 'sourcify'
  s.add_runtime_dependency 'eventmachine'
  s.add_runtime_dependency 'parallel'

end
