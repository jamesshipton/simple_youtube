# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "simple_youtube/version"

Gem::Specification.new do |s|
  s.name        = 'simple_youtube'
  s.version     = SimpleYoutube::VERSION
  s.authors     = ['James Shipton']
  s.email       = ['ionysis@gmail.com']
  s.homepage    = 'https://github.com/jamesshipton/simple_youtube'
  s.summary     = 'ActiveResource extension to Gdata Youtube API.'
  s.description = 'ActiveResource extension to Gdata Youtube API, anonymous Reads, Updates using your API key and OAuth, no Create or Delete access.'

  s.rubyforge_project = 'simple_youtube'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'activeresource', '~> 3.1'
  s.add_dependency 'oauth', '~> 0.4'

  s.add_development_dependency 'fakeweb', '~> 1.3'
  s.add_development_dependency 'rspec', '~> 2.6'
  s.add_development_dependency 'debugger'
end
