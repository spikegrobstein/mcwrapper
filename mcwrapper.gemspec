# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mcwrapper/version'

Gem::Specification.new do |gem|
  gem.name          = "mcwrapper"
  gem.version       = Mcwrapper::VERSION
  gem.authors       = ["Spike Grobstein"]
  gem.email         = ["me@spike.cx"]
  gem.description   = %q{Control your Minecraft server. start/stop and live backups.}
  gem.summary       = %q{Control your Minecraft server. start/stop and live backups.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
