# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "weathercom"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.license     = "MIT"
  s.authors     = ["Oleg Pudeyev"]
  s.email       = "oleg@olegp.name"
  s.homepage    = "https://github.com/p/weathercom"
  s.summary     = "Weather.com API client"
  s.description = "Weather.com API client"

  s.files            = `git ls-files -- lib/*`.split("\n")
  s.files           += %w[README.md LICENSE]
  s.test_files       = []
  s.bindir           = 'bin'
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"
end
